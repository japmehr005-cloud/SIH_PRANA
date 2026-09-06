import 'package:aarogya/domain/communication/emergency_packet.dart';

abstract interface class CommunicationTransport {
  String get id;
  bool get isSimulation;
  Future<EmergencyPacket?> transmit(EmergencyPacket packet);
  Stream<EmergencyPacket> incoming();
}
