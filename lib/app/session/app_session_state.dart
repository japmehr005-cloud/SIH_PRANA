import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/location/location_preference.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';

final class AppSessionState {
  const AppSessionState({
    required this.emergency,
    required this.connectivity,
    required this.ready,
    this.currentSample,
    this.recentSamples = const [],
    this.baseline,
    this.risk,
    this.fallStatus = FallStatus.none,
    this.latestPacket,
    this.simulationActive = false,
    this.engineVersion,
    this.errorMessage,
    this.fallConfirmationDeadline,
    this.lastOnlineAt,
    this.deviceLocation,
    this.guidance,
    this.catalog,
    this.regions,
    this.selectedRegionId,
    this.selectedPlaceId,
    this.locationChoiceLocked = false,
    this.usingGps = false,
    this.deviceLocationRejected = false,
    this.fallCheckCancelled = false,
    this.fallCheckCancelledAt,
    this.nearbyPeers = const [],
    this.receivedPackets = const [],
    this.nearbySharedPackets = const [],
    this.fallDetectionMode = 'simulated-sequence',
    this.heartRateSupported = false,
    this.heartRateConnected = false,
    this.transportId,
    this.demonstrationCondition,
  });

  factory AppSessionState.initial(EmergencySnapshot emergency) {
    return AppSessionState(
      emergency: emergency,
      connectivity: ConnectivityStatus.unknown,
      ready: false,
    );
  }

  final EmergencySnapshot emergency;
  final ConnectivityStatus connectivity;
  final bool ready;
  final SensorSample? currentSample;
  final List<SensorSample> recentSamples;
  final PersonalBaseline? baseline;
  final RiskAssessment? risk;
  final FallStatus fallStatus;
  final EmergencyPacket? latestPacket;
  final bool simulationActive;
  final String? engineVersion;
  final String? errorMessage;
  final DateTime? fallConfirmationDeadline;
  final DateTime? lastOnlineAt;
  final DeviceLocation? deviceLocation;
  final SaferLocationGuidance? guidance;
  final GeographicCatalog? catalog;
  final RegionCatalogSet? regions;
  final String? selectedRegionId;
  final String? selectedPlaceId;
  final bool locationChoiceLocked;
  final bool usingGps;
  final bool deviceLocationRejected;
  final bool fallCheckCancelled;
  final DateTime? fallCheckCancelledAt;
  final List<PeerDevice> nearbyPeers;
  final List<EmergencyPacket> receivedPackets;
  final List<EmergencyPacket> nearbySharedPackets;
  final String fallDetectionMode;
  final bool heartRateSupported;
  final bool heartRateConnected;
  final String? transportId;
  final DemonstrationCondition? demonstrationCondition;

  RiskLevel get visibleRisk => risk?.level ?? RiskLevel.low;

  List<SaferPlace> get inRegionSaferPlaces => catalog?.saferPlaces ?? const [];

  LocationPreference get locationPreference => LocationPreference(
    regionId: selectedRegionId ?? DemonstrationRegionIds.kathmandu,
    lock: usingGps ? LocationLock.gps : LocationLock.demonstration,
    selectedPlaceId: selectedPlaceId,
  );

  List<EmergencyPacket> ownedPackets(List<EmergencyPacket> all) {
    return [
      for (final packet in all)
        if (!packet.isReceivedNearby) packet,
    ];
  }

  AppSessionState copyWith({
    EmergencySnapshot? emergency,
    ConnectivityStatus? connectivity,
    bool? ready,
    SensorSample? currentSample,
    List<SensorSample>? recentSamples,
    PersonalBaseline? baseline,
    RiskAssessment? risk,
    FallStatus? fallStatus,
    EmergencyPacket? latestPacket,
    bool? simulationActive,
    String? engineVersion,
    String? errorMessage,
    DateTime? fallConfirmationDeadline,
    DateTime? lastOnlineAt,
    DeviceLocation? deviceLocation,
    SaferLocationGuidance? guidance,
    GeographicCatalog? catalog,
    RegionCatalogSet? regions,
    String? selectedRegionId,
    String? selectedPlaceId,
    bool? locationChoiceLocked,
    bool? usingGps,
    bool? deviceLocationRejected,
    bool? fallCheckCancelled,
    DateTime? fallCheckCancelledAt,
    List<PeerDevice>? nearbyPeers,
    List<EmergencyPacket>? receivedPackets,
    List<EmergencyPacket>? nearbySharedPackets,
    String? fallDetectionMode,
    bool? heartRateSupported,
    bool? heartRateConnected,
    String? transportId,
    DemonstrationCondition? demonstrationCondition,
    bool clearDemonstrationCondition = false,
    bool clearError = false,
    bool clearFallDeadline = false,
    bool clearGuidance = false,
    bool clearSelectedPlace = false,
    bool clearLocationNotice = false,
    bool clearFallCancelled = false,
    bool clearLatestPacket = false,
  }) {
    return AppSessionState(
      emergency: emergency ?? this.emergency,
      connectivity: connectivity ?? this.connectivity,
      ready: ready ?? this.ready,
      currentSample: currentSample ?? this.currentSample,
      recentSamples: recentSamples ?? this.recentSamples,
      baseline: baseline ?? this.baseline,
      risk: risk ?? this.risk,
      fallStatus: fallStatus ?? this.fallStatus,
      latestPacket: clearLatestPacket
          ? null
          : latestPacket ?? this.latestPacket,
      simulationActive: simulationActive ?? this.simulationActive,
      engineVersion: engineVersion ?? this.engineVersion,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      fallConfirmationDeadline: clearFallDeadline
          ? null
          : fallConfirmationDeadline ?? this.fallConfirmationDeadline,
      lastOnlineAt: lastOnlineAt ?? this.lastOnlineAt,
      deviceLocation: deviceLocation ?? this.deviceLocation,
      guidance: clearGuidance ? null : guidance ?? this.guidance,
      catalog: catalog ?? this.catalog,
      regions: regions ?? this.regions,
      selectedRegionId: selectedRegionId ?? this.selectedRegionId,
      selectedPlaceId: clearSelectedPlace
          ? null
          : selectedPlaceId ?? this.selectedPlaceId,
      locationChoiceLocked: locationChoiceLocked ?? this.locationChoiceLocked,
      usingGps: usingGps ?? this.usingGps,
      deviceLocationRejected: clearLocationNotice
          ? false
          : deviceLocationRejected ?? this.deviceLocationRejected,
      fallCheckCancelled: clearFallCancelled
          ? false
          : fallCheckCancelled ?? this.fallCheckCancelled,
      fallCheckCancelledAt: clearFallCancelled
          ? null
          : fallCheckCancelledAt ?? this.fallCheckCancelledAt,
      nearbyPeers: nearbyPeers ?? this.nearbyPeers,
      receivedPackets: receivedPackets ?? this.receivedPackets,
      nearbySharedPackets: nearbySharedPackets ?? this.nearbySharedPackets,
      fallDetectionMode: fallDetectionMode ?? this.fallDetectionMode,
      heartRateSupported: heartRateSupported ?? this.heartRateSupported,
      heartRateConnected: heartRateConnected ?? this.heartRateConnected,
      transportId: transportId ?? this.transportId,
      demonstrationCondition: clearDemonstrationCondition
          ? null
          : demonstrationCondition ?? this.demonstrationCondition,
    );
  }

  factory AppSessionState.clean({
    required EmergencySnapshot emergency,
    required ConnectivityStatus connectivity,
    String? engineVersion,
    DateTime? lastOnlineAt,
    GeographicCatalog? catalog,
    RegionCatalogSet? regions,
    bool heartRateSupported = false,
    String? transportId,
  }) {
    return AppSessionState(
      emergency: emergency,
      connectivity: connectivity,
      ready: true,
      engineVersion: engineVersion,
      lastOnlineAt: lastOnlineAt,
      catalog: catalog,
      regions: regions,
      heartRateSupported: heartRateSupported,
      transportId: transportId,
    );
  }
}
