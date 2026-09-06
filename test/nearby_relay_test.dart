import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/nearby_presence.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/communication/data/demo_local_transfer.dart';
import 'package:aarogya/features/communication/data/demo_peer_discovery.dart';
import 'package:aarogya/features/communication/data/nearby_inbox_store.dart';
import 'package:aarogya/features/communication/data/nearby_relay_transport.dart';
import 'package:aarogya/features/emergency/data/in_memory_emergency_repository.dart';
import 'package:aarogya/features/health/data/in_memory_health_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

EmergencyPacket _packet({
  required String eventId,
  required String owner,
  String displayName = 'User A',
}) {
  return EmergencyPacket(
    eventId: eventId,
    timestamp: DateTime.utc(2026, 9, 6, 14, 8),
    eventType: 'possible_fall',
    riskLevel: RiskLevel.high,
    fallStatus: FallStatus.criticalUnconfirmed,
    state: PacketState.stored,
    connectivityAtCreation: ConnectivityStatus.offline,
    ownerUserId: owner,
    originDisplayName: displayName,
    heartRateBpm: 118,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'nearby relay delivers a packet to another session without health data',
    () async {
      final prefs = await SharedPreferences.getInstance();
      final inbox = NearbyInboxStore(prefs);
      final healthA = InMemoryHealthRepository();
      final healthB = InMemoryHealthRepository();
      final emergencyB = InMemoryEmergencyRepository();

      await healthA.saveBaseline(
        PersonalBaseline(
          version: 'test',
          sampleCount: 12,
          computedAt: DateTime.utc(2026, 9, 6),
          restingHeartRate: const MetricRange(
            low: 60,
            high: 70,
            median: 65,
          ),
          userId: 'user-a',
        ),
      );

      final transportA = NearbyRelayTransport(inbox, localUserId: 'user-a');
      final transportB = NearbyRelayTransport(inbox, localUserId: 'user-b');
      final received = <EmergencyPacket>[];
      transportB.start();
      final sub = transportB.incoming().listen(received.add);

      final sent = await transportA.transmit(
        _packet(eventId: 'evt-relay-1', owner: 'user-a'),
      );
      expect(sent, isNotNull);
      expect(sent!.state, PacketState.sent);
      expect(sent.hopCount, 1);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(received, isNotEmpty);
      expect(received.single.eventId, 'evt-relay-1');
      expect(received.single.ownerUserId, 'user-a');

      await emergencyB.savePacket(
        received.single.copyWith(receivedByUserId: 'user-b'),
      );
      expect(await healthB.latestBaseline(), isNull);
      expect((await healthA.latestBaseline())?.userId, 'user-a');
      expect(
        (await emergencyB.packetById('evt-relay-1'))?.isReceivedNearby,
        isTrue,
      );

      await sub.cancel();
      await transportA.dispose();
      await transportB.dispose();
    },
  );

  test('forwarding increments hop count on the shared inbox', () async {
    final prefs = await SharedPreferences.getInstance();
    final inbox = NearbyInboxStore(prefs);
    final transport = NearbyRelayTransport(inbox, localUserId: 'user-a');
    final transfer = DemoLocalTransfer(transport);
    await transport.transmit(_packet(eventId: 'evt-hop', owner: 'user-a'));
    final listed = await inbox.packets();
    expect(listed.single.hopCount, 1);

    final forwarded = await transfer.send(
      packet: listed.single,
      peer: const PeerDevice(
        deviceId: 'device-b',
        label: 'User B',
        userId: 'user-b',
      ),
    );
    expect(forwarded, isTrue);
    final again = await inbox.packets();
    expect(again.single.eventId, 'evt-hop');
    expect(again.single.hopCount, 2);
    expect(again.single.state, PacketState.deliveryConfirmed);
    await transport.dispose();
  });

  test('peer discovery lists other published sessions by display name', () async {
    final prefs = await SharedPreferences.getInstance();
    final inbox = NearbyInboxStore(prefs);
    final discovery = DemoPeerDiscovery(inbox, localUserId: 'user-a');
    await inbox.publishPresence(
      NearbyPresence(
        deviceId: 'device-b',
        userId: 'user-b',
        displayName: 'River User',
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    final pending = discovery.watch().first;
    await discovery.start();
    final peers = await pending;
    expect(peers, hasLength(1));
    expect(peers.single.label, 'River User');
    expect(peers.single.userId, 'user-b');
    await discovery.dispose();
  });
}
