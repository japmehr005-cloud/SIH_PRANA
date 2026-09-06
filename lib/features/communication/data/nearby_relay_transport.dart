import 'dart:async';

import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/communication_transport.dart';
import 'package:aarogya/features/communication/data/nearby_broadcast.dart';
import 'package:aarogya/features/communication/data/nearby_inbox_store.dart';

/// Same-origin demonstration relay. Not Bluetooth or mesh radio.
final class NearbyRelayTransport implements CommunicationTransport {
  NearbyRelayTransport(this.store, {this.localUserId = ''});

  final NearbyInboxStore store;
  String localUserId;
  final StreamController<EmergencyPacket> _incoming =
      StreamController<EmergencyPacket>.broadcast();
  final Set<String> _emitted = {};
  bool _listeningBroadcast = false;
  void Function()? _onBroadcast;

  @override
  String get id => 'nearby-demo-relay';

  @override
  bool get isSimulation => true;

  @override
  Stream<EmergencyPacket> incoming() => _incoming.stream;

  void bindUser(String userId) {
    localUserId = userId;
    _emitted.clear();
  }

  void start() {
    if (!_listeningBroadcast) {
      _listeningBroadcast = true;
      _onBroadcast = () {
        unawaited(_emitNew());
      };
      NearbyBroadcast.listen(_onBroadcast!);
    }
    unawaited(_emitNew());
  }

  Future<void> _emitNew() async {
    for (final packet in await store.packets()) {
      if (packet.ownerUserId == localUserId && localUserId.isNotEmpty) {
        continue;
      }
      final key = '${packet.eventId}:${packet.hopCount}:${packet.state.name}';
      if (_emitted.add(key) && !_incoming.isClosed) {
        _incoming.add(packet);
      }
    }
  }

  @override
  Future<EmergencyPacket?> transmit(EmergencyPacket packet) async {
    if (packet.expiresAt != null &&
        DateTime.now().toUtc().isAfter(packet.expiresAt!)) {
      return null;
    }
    final published = packet.copyWith(
      state: packet.hopCount > 0
          ? PacketState.deliveryConfirmed
          : PacketState.sent,
      hopCount: packet.hopCount == 0 ? 1 : packet.hopCount,
    );
    await store.upsert(published);
    await _emitNew();
    return published;
  }

  Future<void> dispose() async {
    if (_onBroadcast != null) {
      NearbyBroadcast.unlisten(_onBroadcast!);
      _onBroadcast = null;
    }
    await _incoming.close();
  }
}
