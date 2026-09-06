import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';

abstract interface class EmergencyRepository {
  Future<void> saveSnapshot(EmergencySnapshot snapshot);
  Future<EmergencySnapshot?> loadSnapshot();
  Future<void> savePacket(EmergencyPacket packet);
  Future<List<EmergencyPacket>> pendingPackets();
  Future<List<EmergencyPacket>> allPackets();
  Future<EmergencyPacket?> packetById(String eventId);
  Future<void> clearEvents();
}

abstract interface class PreferenceRepository {
  Future<void> setLocaleCode(String languageCode);
  Future<String?> localeCode();
}
