import 'dart:async';

import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/communication_transport.dart';

/// In-process hop simulation: origin -> relay -> rescue.
final class SimulatedTransport implements CommunicationTransport {
  SimulatedTransport({this.maxHops = 3});

  final int maxHops;
  final StreamController<EmergencyPacket> _incoming =
      StreamController<EmergencyPacket>.broadcast();
  final List<EmergencyPacket> delivered = [];

  @override
  String get id => 'simulated-mesh';

  @override
  bool get isSimulation => true;

  @override
  Stream<EmergencyPacket> incoming() => _incoming.stream;

  @override
  Future<EmergencyPacket?> transmit(EmergencyPacket packet) async {
    if (packet.expiresAt != null &&
        packet.timestamp.isAfter(packet.expiresAt!)) {
      return null;
    }
    if (delivered.any((item) => item.eventId == packet.eventId)) {
      return delivered.firstWhere((item) => item.eventId == packet.eventId);
    }
    var hop = packet.hopCount;
    while (hop < maxHops) {
      hop += 1;
    }
    final confirmed = packet.copyWith(
      state: PacketState.deliveryConfirmed,
      hopCount: hop,
    );
    delivered.add(confirmed);
    _incoming.add(confirmed);
    return confirmed;
  }

  Future<void> dispose() async {
    await _incoming.close();
  }
}
