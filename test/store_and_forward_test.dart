import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/communication/data/in_memory_connectivity_service.dart';
import 'package:aarogya/features/communication/data/simulated_transport.dart';
import 'package:aarogya/features/emergency/data/in_memory_emergency_repository.dart';
import 'package:aarogya/features/emergency/domain/store_and_forward_service.dart';
import 'package:flutter_test/flutter_test.dart';

EmergencyPacket _packet() {
  return EmergencyPacket(
    eventId: 'evt-1',
    timestamp: DateTime.utc(2026, 9, 6, 14, 8),
    eventType: 'possible_fall',
    riskLevel: RiskLevel.critical,
    fallStatus: FallStatus.criticalUnconfirmed,
    state: PacketState.created,
    connectivityAtCreation: ConnectivityStatus.offline,
    heartRateBpm: 116,
    spo2Percent: 93,
    batteryPercent: 32,
    latitude: 27.72,
    longitude: 85.32,
  );
}

void main() {
  test('stores and queues a packet while offline', () async {
    final repository = InMemoryEmergencyRepository();
    final connectivity = InMemoryConnectivityService(
      ConnectivityStatus.offline,
    );
    final transport = SimulatedTransport();
    final service = StoreAndForwardService(
      repository: repository,
      transport: transport,
      connectivity: connectivity,
    );

    final queued = await service.accept(_packet());
    expect(queued.state, PacketState.queued);
    expect(transport.delivered, isEmpty);
  });

  test(
    'confirms delivery after connectivity is restored without duplicating',
    () async {
      final repository = InMemoryEmergencyRepository();
      final connectivity = InMemoryConnectivityService(
        ConnectivityStatus.offline,
      );
      final transport = SimulatedTransport();
      final service = StoreAndForwardService(
        repository: repository,
        transport: transport,
        connectivity: connectivity,
      );

      await service.accept(_packet());
      connectivity.setStatus(ConnectivityStatus.online);
      final flushed = await service.flushPending();

      expect(flushed, hasLength(1));
      expect(flushed.single.state, PacketState.deliveryConfirmed);
      expect(transport.delivered, hasLength(1));

      final again = await service.flushPending();
      expect(again, isEmpty);
      expect(transport.delivered, hasLength(1));
    },
  );
}
