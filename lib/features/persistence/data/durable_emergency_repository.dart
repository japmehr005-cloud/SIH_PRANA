import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/features/emergency/data/in_memory_emergency_repository.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';

final class DurableEmergencyRepository implements EmergencyRepository {
  DurableEmergencyRepository({
    required this.inner,
    required this.store,
    this.onChanged,
  });

  final InMemoryEmergencyRepository inner;
  final LocalRecordStore store;
  final Future<void> Function()? onChanged;

  Future<void> loadScoped() async {
    final snapshot = await store.snapshot();
    inner.replaceSession(
      snapshot: snapshot != null && _owns(snapshot.userId) ? snapshot : null,
      packets: [
        for (final packet in await store.packets())
          if (_visible(packet)) packet,
      ],
    );
  }

  Future<void> replaceSession({
    EmergencySnapshot? snapshot,
    List<EmergencyPacket> packets = const [],
  }) async {
    inner.replaceSession(snapshot: snapshot, packets: packets);
    await persist();
  }

  Future<void> persist() async {
    await store.saveSnapshot(await inner.loadSnapshot());
    await store.savePackets(await inner.allPackets());
  }

  @override
  Future<void> saveSnapshot(EmergencySnapshot snapshot) async {
    await inner.saveSnapshot(_stampSnapshot(snapshot));
    await persist();
    await onChanged?.call();
  }

  @override
  Future<EmergencySnapshot?> loadSnapshot() => inner.loadSnapshot();

  @override
  Future<void> savePacket(EmergencyPacket packet) async {
    await inner.savePacket(_stampPacket(packet));
    await persist();
    await onChanged?.call();
  }

  @override
  Future<List<EmergencyPacket>> pendingPackets() => inner.pendingPackets();

  @override
  Future<List<EmergencyPacket>> allPackets() => inner.allPackets();

  @override
  Future<EmergencyPacket?> packetById(String eventId) =>
      inner.packetById(eventId);

  @override
  Future<void> clearEvents() async {
    await inner.clearEvents();
    await persist();
    await onChanged?.call();
  }

  EmergencySnapshot _stampSnapshot(EmergencySnapshot snapshot) {
    final owner = _ownerId;
    if (owner == null) {
      return snapshot;
    }
    return snapshot.copyWith(userId: owner);
  }

  EmergencyPacket _stampPacket(EmergencyPacket packet) {
    final owner = _ownerId;
    if (owner == null || packet.ownerUserId.isNotEmpty) {
      return packet;
    }
    return EmergencyPacket(
      eventId: packet.eventId,
      timestamp: packet.timestamp,
      eventType: packet.eventType,
      riskLevel: packet.riskLevel,
      fallStatus: packet.fallStatus,
      state: packet.state,
      connectivityAtCreation: packet.connectivityAtCreation,
      movement: packet.movement,
      heartRateBpm: packet.heartRateBpm,
      spo2Percent: packet.spo2Percent,
      batteryPercent: packet.batteryPercent,
      latitude: packet.latitude,
      longitude: packet.longitude,
      originDeviceId: packet.originDeviceId,
      hopCount: packet.hopCount,
      expiresAt: packet.expiresAt,
      modelVersion: packet.modelVersion,
      riskScore: packet.riskScore,
      contextLabel: packet.contextLabel,
      contextConfidence: packet.contextConfidence,
      baselineHeartRate: packet.baselineHeartRate,
      baselineSpo2: packet.baselineSpo2,
      windowHeartRateMean: packet.windowHeartRateMean,
      rulesScore: packet.rulesScore,
      modelContribution: packet.modelContribution,
      sensorSourceId: packet.sensorSourceId,
      sensorSourceKind: packet.sensorSourceKind,
      fallDetectionMode: packet.fallDetectionMode,
      ownerUserId: owner,
      originDisplayName: packet.originDisplayName,
      receivedByUserId: packet.receivedByUserId,
    );
  }

  String? get _ownerId {
    final scope = store.scope;
    if (scope.isEmpty || scope == 'local') {
      return null;
    }
    return scope;
  }

  bool _owns(String? userId) {
    final owner = _ownerId;
    if (owner == null) {
      return true;
    }
    return userId == null || userId.isEmpty || userId == owner;
  }

  bool _visible(EmergencyPacket packet) {
    final owner = _ownerId;
    if (owner == null) {
      return true;
    }
    if (_owns(packet.ownerUserId)) {
      return true;
    }
    return packet.receivedByUserId == owner;
  }
}
