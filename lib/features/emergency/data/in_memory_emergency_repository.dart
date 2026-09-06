import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';

final class InMemoryEmergencyRepository implements EmergencyRepository {
  EmergencySnapshot? _snapshot;
  final Map<String, EmergencyPacket> _packets = {};

  @override
  Future<void> saveSnapshot(EmergencySnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<EmergencySnapshot?> loadSnapshot() async => _snapshot;

  @override
  Future<void> savePacket(EmergencyPacket packet) async {
    _packets[packet.eventId] = packet;
  }

  @override
  Future<List<EmergencyPacket>> pendingPackets() async {
    return _packets.values
        .where(
          (packet) =>
              packet.state == PacketState.stored ||
              packet.state == PacketState.queued ||
              packet.state == PacketState.failed,
        )
        .toList();
  }

  @override
  Future<List<EmergencyPacket>> allPackets() async => _packets.values.toList();

  @override
  Future<EmergencyPacket?> packetById(String eventId) async =>
      _packets[eventId];

  @override
  Future<void> clearEvents() async {
    _snapshot = null;
    _packets.clear();
  }

  void replaceSession({
    EmergencySnapshot? snapshot,
    List<EmergencyPacket> packets = const [],
  }) {
    _snapshot = snapshot;
    _packets
      ..clear()
      ..addEntries(packets.map((packet) => MapEntry(packet.eventId, packet)));
  }
}

final class InMemoryPreferenceRepository implements PreferenceRepository {
  String? _localeCode;

  @override
  Future<void> setLocaleCode(String languageCode) async {
    _localeCode = languageCode;
  }

  @override
  Future<String?> localeCode() async => _localeCode;
}
