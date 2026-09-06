import 'dart:async';

import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/result.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/nearby_presence.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/domain/contracts/connectivity_service.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/contracts/health_repository.dart';
import 'package:aarogya/domain/contracts/inference_engine.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/contracts/replay_sensor_sink.dart';
import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/emergency/disaster_activation_source.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_command.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/emergency/emergency_state_machine.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/location/location_preference.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';
import 'package:aarogya/features/baseline/domain/personal_baseline_engine.dart';
import 'package:aarogya/features/communication/data/demo_peer_discovery.dart';
import 'package:aarogya/features/communication/data/nearby_relay_transport.dart';
import 'package:aarogya/features/emergency/domain/emergency_packet_factory.dart';
import 'package:aarogya/features/emergency/domain/store_and_forward_service.dart';
import 'package:aarogya/features/location/data/composite_location_service.dart';
import 'package:aarogya/features/location/data/sample_backed_location_service.dart';
import 'package:aarogya/features/location/domain/safer_location_engine.dart';
import 'package:aarogya/features/sensors/data/csv_replay_sensor_source.dart';
import 'package:aarogya/features/sensors/data/sensor_preprocessor.dart';
import 'package:aarogya/features/sensors/data/web_bluetooth_heart_rate.dart';

final class AarogyaRuntime {
  AarogyaRuntime({
    required this.machine,
    required this.health,
    required this.emergency,
    required this.inference,
    required this.sensors,
    required this.storeAndForward,
    required this.packetFactory,
    required this.connectivity,
    required this.location,
    required this.clock,
    this.peers = const UnsupportedPeerDiscovery(),
    this.localTransfer = const UnsupportedLocalTransfer(),
    this.heartRateSource,
    this.preprocessor = const SensorPreprocessor(),
    this.baselineEngine = const PersonalBaselineEngine(),
    this.replay = const CsvSensorReplay(),
    this.fallConfirmationWindow = const Duration(seconds: 20),
    this.guidanceEngine,
    this.catalog,
    this.regions,
    this.records,
  });

  final EmergencyStateMachine machine;
  final HealthRepository health;
  final EmergencyRepository emergency;
  final InferenceEngine inference;
  final SensorSource sensors;
  final StoreAndForwardService storeAndForward;
  final EmergencyPacketFactory packetFactory;
  final ConnectivityService connectivity;
  final LocationService location;
  final Clock clock;
  final PeerDiscovery peers;
  final LocalTransfer localTransfer;
  final WebBluetoothHeartRateSource? heartRateSource;
  final SensorPreprocessor preprocessor;
  final PersonalBaselineEngine baselineEngine;
  final CsvSensorReplay replay;
  final Duration fallConfirmationWindow;
  SaferLocationEngine? guidanceEngine;
  GeographicCatalog? catalog;
  RegionCatalogSet? regions;
  LocalRecordStore? records;

  final StreamController<AppSessionState> _states =
      StreamController<AppSessionState>.broadcast();
  StreamSubscription<SensorSample>? _sensorSub;
  StreamSubscription<ConnectivityStatus>? _connectivitySub;
  StreamSubscription<EmergencyPacket>? _incomingSub;
  StreamSubscription<List<PeerDevice>>? _peerSub;
  Future<void> _ingestChain = Future<void>.value();
  bool _suppressAutomaticEmergency = false;

  late AppSessionState _state = AppSessionState(
    emergency: machine.snapshot,
    connectivity: connectivity.current,
    ready: false,
    heartRateSupported: heartRateSource?.isSupported ?? false,
    transportId: storeAndForward.transport.id,
    catalog: catalog,
  );

  AppSessionState get state => _state;
  Stream<AppSessionState> get states => _states.stream;

  Future<void> start() async {
    await _ensureCatalog();
    await restorePersisted();
    await sensors.start();
    _sensorSub = sensors.watch().listen((sample) {
      _ingestChain = _ingestChain
          .then((_) => ingest(sample))
          .catchError((_) {});
    });
    _connectivitySub = connectivity.watch().listen((status) {
      unawaited(_onConnectivity(status));
    });
    _incomingSub = storeAndForward.transport.incoming().listen((packet) {
      unawaited(_onIncoming(packet));
    });
    _peerSub = peers.watch().listen((items) {
      _publish(_state.copyWith(nearbyPeers: items));
      unawaited(_refreshNearbyShared());
    });
    final transport = storeAndForward.transport;
    if (transport is NearbyRelayTransport) {
      transport.start();
    }
    await peers.start();
    await _hydrateLocation();
  }

  Future<void> bindSession({
    required String userId,
    required String displayName,
    required String deviceId,
  }) async {
    packetFactory.ownerUserId = userId;
    packetFactory.originDisplayName = displayName;
    packetFactory.originDeviceId = deviceId;
    final transport = storeAndForward.transport;
    if (transport is NearbyRelayTransport) {
      transport.bindUser(userId);
      transport.start();
    }
    if (userId.isNotEmpty && peers is DemoPeerDiscovery) {
      await (peers as DemoPeerDiscovery).publish(
        NearbyPresence(
          deviceId: deviceId,
          userId: userId,
          displayName: displayName.isEmpty ? 'PRANA user' : displayName,
          updatedAt: clock.now().toUtc(),
        ),
      );
    }
    await peers.start();
  }

  Future<void> dispose() async {
    await _sensorSub?.cancel();
    await _connectivitySub?.cancel();
    await _incomingSub?.cancel();
    await _peerSub?.cancel();
    await peers.stop();
    await sensors.stop();
    final transport = storeAndForward.transport;
    if (transport is NearbyRelayTransport) {
      await transport.dispose();
    }
    await _states.close();
  }

  Future<void> ingest(SensorSample raw) async {
    final sample = preprocessor.process(raw);
    if (!_state.locationChoiceLocked) {
      location.observeSample(sample);
    }
    await health.saveSample(sample);
    _applyLocalLocation(sample);

    final recent = await health.recentSamples();
    var baseline = await health.latestBaseline();
    final computed = baselineEngine.compute(
      samples: recent,
      computedAt: clock.now(),
    );
    if (computed != null && computed.isEstablished) {
      await health.saveBaseline(computed);
      baseline = computed;
    } else if (computed != null) {
      baseline = computed;
    }

    final result = inference.infer(
      InferenceInput(
        current: sample,
        recent: recent,
        phase: machine.snapshot.phase,
        baseline: baseline,
        disasterType: machine.snapshot.disasterType,
      ),
    );

    var fallStatus = result.fallStatus;
    DateTime? deadline = _state.fallConfirmationDeadline;
    if (fallStatus == FallStatus.possible) {
      fallStatus = FallStatus.awaitingConfirmation;
      deadline = clock.now().add(fallConfirmationWindow);
      _state = _state.copyWith(clearFallCancelled: true);
    } else if (_state.fallStatus == FallStatus.awaitingConfirmation) {
      fallStatus = FallStatus.awaitingConfirmation;
    }

    if (fallStatus == FallStatus.awaitingConfirmation &&
        deadline != null &&
        !clock.now().isBefore(deadline) &&
        !_suppressAutomaticEmergency) {
      await escalateUnconfirmedFall(sample: sample, result: result);
      return;
    }

    if (result.risk.level == RiskLevel.critical &&
        machine.snapshot.phase == EmergencyPhase.survival &&
        fallStatus != FallStatus.awaitingConfirmation &&
        !_suppressAutomaticEmergency &&
        _state.latestPacket == null) {
      await _createEvent(
        eventType: 'physiological_deterioration',
        result: result,
        sample: sample,
        fallStatus: fallStatus,
      );
      return;
    }

    _publish(
      _state.copyWith(
        currentSample: sample,
        recentSamples: _uiRecent(recent),
        baseline: baseline,
        risk: result.risk,
        fallStatus: fallStatus,
        fallConfirmationDeadline: deadline,
        emergency: machine.snapshot,
        connectivity: connectivity.current,
        simulationActive: sample.isSimulation,
        engineVersion: result.engineVersion,
        fallDetectionMode: result.fallDetectionMode,
        ready: true,
        heartRateConnected: heartRateSource?.connected ?? false,
      ),
    );
  }

  Future<void> replayCsv(String csv, {String sourceId = 'csv-replay'}) async {
    final samples = replay.parse(csv, sourceId: sourceId);
    switch (sensors) {
      case ReplaySensorSink sink:
        await sink.emitAll(samples);
        await _ingestChain;
      default:
        for (final sample in samples) {
          await ingest(sample);
        }
    }
  }

  Future<void> applyDemonstrationCondition(
    DemonstrationCondition condition, {
    required String csv,
    String? restingCsv,
  }) async {
    if (condition != DemonstrationCondition.resting &&
        _state.baseline?.isEstablished != true &&
        restingCsv != null) {
      await replayCsv(
        restingCsv,
        sourceId: DemonstrationCondition.resting.assetPath,
      );
    }
    final suppress = condition == DemonstrationCondition.fallImpact;
    _suppressAutomaticEmergency = suppress;
    try {
      await replayCsv(csv, sourceId: condition.assetPath);
    } finally {
      _suppressAutomaticEmergency = false;
    }
    await records?.saveDemonstrationCondition(condition.id);
    _publish(_state.copyWith(demonstrationCondition: condition));
  }

  Future<void> activateOfficialFlood() async {
    final result = machine.apply(
      const ActivateDisaster(
        disasterType: DisasterType.flood,
        source: DisasterActivationSource.officialWarning,
      ),
    );
    await _persistMachine(result);
  }

  Future<void> confirmDisaster() async {
    await _persistMachine(machine.apply(const ConfirmDisaster()));
  }

  Future<void> enterSurvival() async {
    if (machine.snapshot.phase == EmergencyPhase.disasterAlert) {
      await confirmDisaster();
    }
    await _persistMachine(machine.apply(const EnterSurvival()));
  }

  Future<void> resolveEmergency() async {
    await _persistMachine(machine.apply(const ResolveEmergency()));
  }

  Future<void> resetToNormal() async {
    await _persistMachine(machine.apply(const ResetToNormal()));
  }

  Future<void> resetDemo() async {
    await health.clearSessionData();
    await emergency.clearEvents();
    machine.hydrate(EmergencySnapshot.normal(clock.now()));
    await emergency.saveSnapshot(machine.snapshot);
    connectivity.setStatus(ConnectivityStatus.online);
    await records?.saveDemonstrationCondition(null);
    _publish(
      AppSessionState.clean(
        emergency: machine.snapshot,
        connectivity: ConnectivityStatus.online,
        engineVersion: inference.version,
        lastOnlineAt: clock.now(),
        catalog: catalog,
        regions: regions,
        heartRateSupported: heartRateSource?.isSupported ?? false,
        transportId: storeAndForward.transport.id,
      ),
    );
    unawaited(_hydrateLocation());
  }

  Future<void> userIsOk() async {
    _publish(
      _state.copyWith(
        fallStatus: FallStatus.none,
        clearFallDeadline: true,
        fallCheckCancelled: true,
        fallCheckCancelledAt: clock.now(),
      ),
    );
  }

  Future<void> userNeedsHelp() async {
    final current = _state.currentSample;
    final assessment = _state.risk;
    if (current == null || assessment == null) {
      return;
    }
    await _createEvent(
      eventType: 'possible_fall',
      result: InferenceResult(
        risk: assessment,
        fallStatus: FallStatus.criticalUnconfirmed,
        engineName: inference.name,
        engineVersion: inference.version,
        fallDetectionMode: _state.fallDetectionMode,
      ),
      sample: current,
      fallStatus: FallStatus.criticalUnconfirmed,
    );
  }

  Future<void> escalateUnconfirmedFall({
    SensorSample? sample,
    InferenceResult? result,
  }) async {
    final current = sample ?? _state.currentSample;
    if (current == null) {
      return;
    }
    final assessment = result?.risk ?? _state.risk;
    if (assessment == null) {
      return;
    }
    await _createEvent(
      eventType: 'possible_fall',
      result:
          result ??
          InferenceResult(
            risk: assessment,
            fallStatus: FallStatus.criticalUnconfirmed,
            engineName: inference.name,
            engineVersion: inference.version,
            fallDetectionMode: _state.fallDetectionMode,
          ),
      sample: current,
      fallStatus: FallStatus.criticalUnconfirmed,
    );
  }

  Future<void> setConnectivity(ConnectivityStatus status) async {
    connectivity.setStatus(status);
    await _onConnectivity(status);
  }

  Future<void> requestLocationAccess() async {
    await location.requestPermission();
    final gps = await _readGpsFix();
    if (gps == null) {
      return;
    }
    final here = GeoPoint(latitude: gps.latitude, longitude: gps.longitude);
    final region = regions?.containing(here);
    if (region == null) {
      _publish(_state.copyWith(deviceLocationRejected: true));
      return;
    }
    await _applyChosenLocation(
      gps,
      regionId: region.id,
      locked: true,
      usingGps: true,
      clearPlace: true,
    );
  }

  Future<void> selectDemonstrationRegion(String regionId) async {
    final region = regions?.byId(regionId);
    if (region == null) {
      return;
    }
    final center = _centerFor(region);
    final fix = DeviceLocation(
      latitude: center.latitude,
      longitude: center.longitude,
      capturedAt: clock.now().toUtc(),
      isLastKnown: true,
      source: LocationSource.demonstration,
    );
    _writeDemonstrationFix(fix, ignoreSamples: true);
    await _applyChosenLocation(
      fix,
      regionId: region.id,
      locked: true,
      usingGps: false,
      clearPlace: true,
    );
  }

  Future<void> selectSaferPlace(String placeId) async {
    final fix = _state.deviceLocation;
    if (fix == null) {
      return;
    }
    await _applyChosenLocation(
      fix,
      regionId: _state.selectedRegionId ?? catalog?.id,
      locked: _state.locationChoiceLocked,
      usingGps: _state.usingGps,
      selectedPlaceId: placeId,
    );
  }

  Future<void> receiveFromPeer(PeerDevice peer) async {
    final transport = storeAndForward.transport;
    if (transport is! NearbyRelayTransport) {
      return;
    }
    for (final packet in await transport.store.packets()) {
      if (peer.userId != null &&
          packet.ownerUserId == peer.userId &&
          packet.ownerUserId != packetFactory.ownerUserId) {
        final existing = await emergency.packetById(packet.eventId);
        if (existing != null) {
          continue;
        }
        await _onIncoming(packet);
      }
    }
    await _refreshNearbyShared();
  }

  Future<bool> connectHeartRate() async {
    final source = heartRateSource;
    if (source == null) {
      return false;
    }
    final ok = await source.connect();
    _publish(
      _state.copyWith(
        heartRateConnected: source.connected,
        heartRateSupported: source.isSupported,
      ),
    );
    return ok;
  }

  Future<void> forwardToPeer(EmergencyPacket packet, PeerDevice peer) async {
    final sent = await localTransfer.send(packet: packet, peer: peer);
    if (!sent) {
      return;
    }
    await emergency.savePacket(
      packet.copyWith(
        hopCount: packet.hopCount + 1,
        state: PacketState.deliveryConfirmed,
      ),
    );
    await _publishPackets();
  }

  Future<void> _createEvent({
    required String eventType,
    required InferenceResult result,
    required SensorSample sample,
    required FallStatus fallStatus,
  }) async {
    final fix = _state.deviceLocation ?? await location.currentLocation();
    var packet = packetFactory.create(
      eventType: eventType,
      risk: result.risk,
      fallStatus: fallStatus,
      sample: sample,
      connectivity: connectivity.current,
      location: fix,
      fallDetectionMode: result.fallDetectionMode,
    );
    final recorded = machine.apply(
      RecordEmergencyEvent(eventId: packet.eventId),
    );
    await _persistMachine(recorded);
    packet = await storeAndForward.accept(packet);
    final recent = await health.recentSamples();
    _publish(
      _state.copyWith(
        currentSample: sample,
        recentSamples: _uiRecent(recent),
        risk: result.risk,
        fallStatus: fallStatus,
        latestPacket: packet,
        emergency: machine.snapshot,
        connectivity: connectivity.current,
        engineVersion: result.engineVersion,
        fallDetectionMode: result.fallDetectionMode,
        ready: true,
        clearFallDeadline: true,
      ),
    );
  }

  Future<void> _onIncoming(EmergencyPacket packet) async {
    final me = packetFactory.ownerUserId;
    if (me.isEmpty || packet.ownerUserId.isEmpty || packet.ownerUserId == me) {
      return;
    }
    final stamped = packet.copyWith(receivedByUserId: me);
    await emergency.savePacket(stamped);
    await _publishPackets(latestReceived: stamped);
  }

  Future<void> _publishPackets({EmergencyPacket? latestReceived}) async {
    final packets = await emergency.allPackets();
    packets.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final received = [
      for (final packet in packets)
        if (packet.isReceivedNearby) packet,
    ];
    final owned = [
      for (final packet in packets)
        if (!packet.isReceivedNearby) packet,
    ];
    _publish(
      _state.copyWith(
        receivedPackets: received,
        latestPacket: owned.isEmpty
            ? (_state.latestPacket ?? latestReceived)
            : owned.first,
      ),
    );
  }

  Future<void> _onConnectivity(ConnectivityStatus status) async {
    if (status.canTransmit) {
      final flushed = await storeAndForward.flushPending();
      if (flushed.isNotEmpty) {
        _publish(
          _state.copyWith(
            latestPacket: flushed.last,
            connectivity: status,
            emergency: machine.snapshot,
            lastOnlineAt: clock.now(),
          ),
        );
        return;
      }
      _publish(
        _state.copyWith(
          connectivity: status,
          emergency: machine.snapshot,
          lastOnlineAt: clock.now(),
        ),
      );
      return;
    }
    _publish(
      _state.copyWith(connectivity: status, emergency: machine.snapshot),
    );
  }

  Future<void> _persistMachine(Result<EmergencySnapshot> result) async {
    if (result is Failure<EmergencySnapshot>) {
      _publish(_state.copyWith(errorMessage: result.error.toString()));
      return;
    }
    await emergency.saveSnapshot(machine.snapshot);
    _publish(_state.copyWith(emergency: machine.snapshot, clearError: true));
  }

  Future<void> restorePersisted({RiskAssessment? risk}) async {
    final stored = await emergency.loadSnapshot();
    if (stored != null) {
      machine.hydrate(stored);
    } else {
      machine.hydrate(EmergencySnapshot.normal(clock.now()));
    }
    final baseline = await health.latestBaseline();
    final recent = await health.recentSamples();
    final packets = await emergency.allPackets();
    packets.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final received = [
      for (final packet in packets)
        if (packet.isReceivedNearby) packet,
    ];
    final owned = [
      for (final packet in packets)
        if (!packet.isReceivedNearby) packet,
    ];
    final status = connectivity.current;
    _publish(
      AppSessionState(
        emergency: machine.snapshot,
        connectivity: status,
        ready: true,
        currentSample: recent.isEmpty ? null : recent.last,
        recentSamples: _uiRecent(recent),
        baseline: baseline,
        risk: risk,
        latestPacket: owned.isEmpty ? null : owned.first,
        receivedPackets: received,
        simulationActive: recent.any((sample) => sample.isSimulation),
        engineVersion: inference.version,
        lastOnlineAt: status.canTransmit ? clock.now() : _state.lastOnlineAt,
        catalog: catalog,
        regions: regions,
        heartRateSupported: heartRateSource?.isSupported ?? false,
        heartRateConnected: heartRateSource?.connected ?? false,
        transportId: storeAndForward.transport.id,
        nearbyPeers: _state.nearbyPeers,
        nearbySharedPackets: _state.nearbySharedPackets,
        fallDetectionMode: _state.fallDetectionMode,
        demonstrationCondition: DemonstrationCondition.tryParse(
          await records?.demonstrationCondition(),
        ),
      ),
    );
    await _hydrateLocation();
    await _refreshNearbyShared();
  }

  void _applyLocalLocation(SensorSample sample) {
    if (_state.locationChoiceLocked || !sample.hasLocation) {
      return;
    }
    if (_state.usingGps) {
      return;
    }
    final demo = DeviceLocation(
      latitude: sample.latitude!,
      longitude: sample.longitude!,
      capturedAt: sample.timestamp,
      isLastKnown: true,
      source: LocationSource.demonstration,
    );
    unawaited(
      _applyChosenLocation(
        demo,
        regionId: regions
            ?.containing(
              GeoPoint(latitude: demo.latitude, longitude: demo.longitude),
            )
            ?.id,
        locked: false,
        usingGps: false,
      ),
    );
  }

  Future<void> _hydrateLocation() async {
    final stored = await records?.locationPreference();
    if (stored?.lock == LocationLock.gps) {
      final gps = await _readGpsFix();
      if (gps != null) {
        final region = regions?.containing(
          GeoPoint(latitude: gps.latitude, longitude: gps.longitude),
        );
        if (region != null) {
          await _applyChosenLocation(
            gps,
            regionId: region.id,
            locked: true,
            usingGps: true,
            selectedPlaceId: stored?.selectedPlaceId,
            persist: false,
          );
          return;
        }
      }
    }
    final regionId = stored?.regionId ?? DemonstrationRegionIds.kathmandu;
    final region = regions?.byId(regionId);
    if (region != null) {
      final center = _centerFor(region);
      final fix = DeviceLocation(
        latitude: center.latitude,
        longitude: center.longitude,
        capturedAt: clock.now().toUtc(),
        isLastKnown: true,
        source: LocationSource.demonstration,
      );
      _writeDemonstrationFix(
        fix,
        ignoreSamples: stored != null,
      );
      await _applyChosenLocation(
        fix,
        regionId: region.id,
        locked: stored != null,
        usingGps: false,
        selectedPlaceId: stored?.selectedPlaceId,
        persist: false,
      );
      return;
    }
    final fallback = await location.currentLocation();
    if (fallback != null && fallback.source != LocationSource.gps) {
      await _applyChosenLocation(
        fallback,
        regionId: regions
            ?.containing(
              GeoPoint(
                latitude: fallback.latitude,
                longitude: fallback.longitude,
              ),
            )
            ?.id,
        locked: false,
        usingGps: false,
        persist: false,
      );
    }
  }

  Future<void> _applyChosenLocation(
    DeviceLocation fix, {
    String? regionId,
    required bool locked,
    required bool usingGps,
    String? selectedPlaceId,
    bool clearPlace = false,
    bool persist = true,
  }) async {
    final resolvedId = regionId ??
        regions
            ?.containing(
              GeoPoint(latitude: fix.latitude, longitude: fix.longitude),
            )
            ?.id;
    final active = resolvedId == null ? catalog : regions?.byId(resolvedId);
    catalog = active ?? catalog;
    final guidance = guidanceEngine?.guide(
      fix,
      selectedRegionId: resolvedId,
      selectedPlaceId: clearPlace ? null : selectedPlaceId,
    );
    _publish(
      _state.copyWith(
        deviceLocation: fix,
        guidance: guidance,
        clearGuidance: guidance == null,
        catalog: catalog,
        regions: regions,
        selectedRegionId: resolvedId,
        selectedPlaceId: clearPlace ? null : selectedPlaceId,
        clearSelectedPlace: clearPlace,
        locationChoiceLocked: locked,
        usingGps: usingGps,
        clearLocationNotice: true,
      ),
    );
    if (persist) {
      await records?.saveLocationPreference(_state.locationPreference);
    }
  }

  Future<DeviceLocation?> _readGpsFix() async {
    final service = location;
    if (service is CompositeLocationService) {
      return service.gpsFix();
    }
    final fix = await service.currentLocation();
    if (fix != null && fix.source == LocationSource.gps) {
      return fix;
    }
    return null;
  }

  void _writeDemonstrationFix(
    DeviceLocation fix, {
    required bool ignoreSamples,
  }) {
    final service = location;
    if (service is SampleBackedLocationService) {
      service.setFix(fix);
      service.ignoreSamples = ignoreSamples;
    } else if (service is CompositeLocationService &&
        service.demonstration is SampleBackedLocationService) {
      final demo = service.demonstration as SampleBackedLocationService;
      demo.setFix(fix);
      demo.ignoreSamples = ignoreSamples;
    }
  }

  GeoPoint _centerFor(GeographicCatalog region) {
    if (region.id == DemonstrationRegionIds.delhi) {
      return const GeoPoint(
        latitude: DemonstrationRegionCenters.delhiLatitude,
        longitude: DemonstrationRegionCenters.delhiLongitude,
      );
    }
    if (region.id == DemonstrationRegionIds.kathmandu) {
      return const GeoPoint(
        latitude: DemonstrationRegionCenters.kathmanduLatitude,
        longitude: DemonstrationRegionCenters.kathmanduLongitude,
      );
    }
    return region.demonstrationCenter;
  }

  Future<void> _refreshNearbyShared() async {
    final transport = storeAndForward.transport;
    if (transport is! NearbyRelayTransport) {
      return;
    }
    final me = packetFactory.ownerUserId;
    final shared = [
      for (final packet in await transport.store.packets())
        if (packet.ownerUserId != me) packet,
    ];
    _publish(_state.copyWith(nearbySharedPackets: shared));
  }

  Future<void> _ensureCatalog() async {
    if (regions != null && guidanceEngine != null) {
      catalog ??= regions!.byId(DemonstrationRegionIds.kathmandu) ??
          (regions!.catalogs.isEmpty ? null : regions!.catalogs.first);
      _publish(_state.copyWith(catalog: catalog, regions: regions));
      return;
    }
    try {
      regions ??= await loadDemonstrationRegions();
      guidanceEngine ??= SaferLocationEngine(regions: regions!);
      catalog ??= regions!.byId(DemonstrationRegionIds.kathmandu) ??
          (regions!.catalogs.isEmpty ? null : regions!.catalogs.first);
      _publish(_state.copyWith(catalog: catalog, regions: regions));
    } catch (_) {
      try {
        catalog ??= await loadKathmanduCatalog();
        regions ??= RegionCatalogSet([catalog!]);
        guidanceEngine ??= SaferLocationEngine(regions: regions!);
        _publish(_state.copyWith(catalog: catalog, regions: regions));
      } catch (_) {}
    }
  }

  void _publish(AppSessionState next) {
    _state = next;
    if (!_states.isClosed) {
      _states.add(next);
    }
  }

  List<SensorSample> _uiRecent(List<SensorSample> recent) {
    if (recent.length <= 8) {
      return List.unmodifiable(recent);
    }
    return List.unmodifiable(recent.sublist(recent.length - 8));
  }
}
