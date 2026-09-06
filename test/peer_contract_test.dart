import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/emergency/domain/store_and_forward_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unsupported peer discovery and transfer stay inert for tests', () async {
    const discovery = UnsupportedPeerDiscovery();
    const transfer = UnsupportedLocalTransfer();
    expect(await discovery.watch().first, isEmpty);
    await discovery.start();
    final sent = await transfer.send(
      packet: EmergencyPacket(
        eventId: 'evt-1',
        timestamp: DateTime.utc(2026, 9, 6),
        eventType: 'possible_fall',
        riskLevel: RiskLevel.high,
        fallStatus: FallStatus.possible,
        state: PacketState.stored,
        connectivityAtCreation: ConnectivityStatus.offline,
      ),
      peer: const PeerDevice(deviceId: 'peer-1'),
    );
    expect(sent, isFalse);
    await discovery.stop();
  });

  test('store-and-forward queue is the existing service', () {
    expect(StoreAndForwardQueue, same(StoreAndForwardService));
  });
}
