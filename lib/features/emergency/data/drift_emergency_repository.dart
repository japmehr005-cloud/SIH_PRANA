import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/features/health/data/local/aarogya_database.dart';
import 'package:drift/drift.dart';

final class DriftEmergencyRepository implements EmergencyRepository {
  DriftEmergencyRepository(this._db);

  final AarogyaDatabase _db;

  @override
  Future<void> saveSnapshot(EmergencySnapshot snapshot) {
    return _db
        .into(_db.disasterStates)
        .insertOnConflictUpdate(
          DisasterStatesCompanion.insert(
            id: const Value(1),
            phase: snapshot.phase.name,
            updatedAt: snapshot.updatedAt,
            disasterType: Value(snapshot.disasterType?.name),
            activationSource: Value(snapshot.activationSource?.name),
            lastEventId: Value(snapshot.lastEventId),
            stranded: Value(snapshot.stranded),
          ),
        );
  }

  @override
  Future<EmergencySnapshot?> loadSnapshot() async {
    final row = await (_db.select(
      _db.disasterStates,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    return row == null ? null : _db.mapSnapshot(row);
  }

  @override
  Future<void> savePacket(EmergencyPacket packet) {
    return _db
        .into(_db.emergencyEvents)
        .insertOnConflictUpdate(
          EmergencyEventsCompanion.insert(
            eventId: packet.eventId,
            timestamp: packet.timestamp,
            eventType: packet.eventType,
            riskLevel: packet.riskLevel.name,
            fallStatus: packet.fallStatus.name,
            state: packet.state.name,
            connectivity: packet.connectivityAtCreation.name,
            movement: Value(packet.movement?.name),
            heartRateBpm: Value(packet.heartRateBpm),
            spo2Percent: Value(packet.spo2Percent),
            batteryPercent: Value(packet.batteryPercent),
            latitude: Value(packet.latitude),
            longitude: Value(packet.longitude),
            originDeviceId: packet.originDeviceId,
            hopCount: Value(packet.hopCount),
            expiresAt: Value(packet.expiresAt),
          ),
        );
  }

  @override
  Future<List<EmergencyPacket>> pendingPackets() async {
    final rows =
        await (_db.select(_db.emergencyEvents)..where(
              (t) =>
                  t.state.equals(PacketState.stored.name) |
                  t.state.equals(PacketState.queued.name) |
                  t.state.equals(PacketState.failed.name),
            ))
            .get();
    return rows.map(_db.mapPacket).toList();
  }

  @override
  Future<List<EmergencyPacket>> allPackets() async {
    final rows = await _db.select(_db.emergencyEvents).get();
    return rows.map(_db.mapPacket).toList();
  }

  @override
  Future<EmergencyPacket?> packetById(String eventId) async {
    final row = await (_db.select(
      _db.emergencyEvents,
    )..where((t) => t.eventId.equals(eventId))).getSingleOrNull();
    return row == null ? null : _db.mapPacket(row);
  }

  @override
  Future<void> clearEvents() async {
    await _db.delete(_db.emergencyEvents).go();
    await _db.delete(_db.disasterStates).go();
  }
}

final class DriftPreferenceRepository implements PreferenceRepository {
  DriftPreferenceRepository(this._db);

  final AarogyaDatabase _db;

  static const localeKey = 'locale';

  @override
  Future<void> setLocaleCode(String languageCode) {
    return _db
        .into(_db.appPreferences)
        .insertOnConflictUpdate(
          AppPreferencesCompanion.insert(key: localeKey, value: languageCode),
        );
  }

  @override
  Future<String?> localeCode() async {
    final row = await (_db.select(
      _db.appPreferences,
    )..where((t) => t.key.equals(localeKey))).getSingleOrNull();
    return row?.value;
  }
}
