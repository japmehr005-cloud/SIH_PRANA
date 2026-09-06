import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/features/communication/data/nearby_relay_transport.dart';

final class DemoLocalTransfer implements LocalTransfer {
  DemoLocalTransfer(this.transport);

  final NearbyRelayTransport transport;

  @override
  Future<bool> send({
    required EmergencyPacket packet,
    required PeerDevice peer,
  }) async {
    final forwarded = packet.copyWith(
      hopCount: packet.hopCount + 1,
      state: PacketState.deliveryConfirmed,
    );
    final result = await transport.transmit(forwarded);
    return result != null;
  }
}
