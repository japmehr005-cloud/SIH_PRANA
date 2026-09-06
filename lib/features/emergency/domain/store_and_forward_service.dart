import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/communication_transport.dart';
import 'package:aarogya/domain/contracts/connectivity_service.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';

/// Local emergency-packet queue. Nearby radio transfer is a separate contract.
typedef StoreAndForwardQueue = StoreAndForwardService;

final class StoreAndForwardService {
  StoreAndForwardService({
    required this.repository,
    required this.transport,
    required this.connectivity,
  });

  final EmergencyRepository repository;
  final CommunicationTransport transport;
  final ConnectivityService connectivity;

  Future<EmergencyPacket> accept(EmergencyPacket packet) async {
    final stored = packet.copyWith(state: PacketState.stored);
    await repository.savePacket(stored);
    return flush(stored);
  }

  Future<EmergencyPacket> flush(EmergencyPacket packet) async {
    if (!connectivity.current.canTransmit) {
      final queued = packet.copyWith(state: PacketState.queued);
      await repository.savePacket(queued);
      return queued;
    }

    final transmitting = packet.copyWith(state: PacketState.transmitting);
    await repository.savePacket(transmitting);

    final confirmed = await transport.transmit(transmitting);
    if (confirmed == null) {
      final failed = transmitting.copyWith(state: PacketState.failed);
      await repository.savePacket(failed);
      return failed;
    }
    await repository.savePacket(confirmed);
    return confirmed;
  }

  Future<List<EmergencyPacket>> flushPending() async {
    final pending = await repository.pendingPackets();
    final results = <EmergencyPacket>[];
    for (final packet in pending) {
      results.add(await flush(packet));
    }
    return results;
  }
}
