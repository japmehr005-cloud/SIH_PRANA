import 'dart:async';

import 'package:aarogya/domain/communication/nearby_presence.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/features/communication/data/nearby_broadcast.dart';
import 'package:aarogya/features/communication/data/nearby_inbox_store.dart';

final class DemoPeerDiscovery implements PeerDiscovery {
  DemoPeerDiscovery(this.store, {this.localUserId = ''});

  final NearbyInboxStore store;
  String localUserId;
  final StreamController<List<PeerDevice>> _peers =
      StreamController<List<PeerDevice>>.broadcast();
  bool _listeningBroadcast = false;
  void Function()? _onBroadcast;

  @override
  Stream<List<PeerDevice>> watch() => _peers.stream;

  @override
  Future<void> start() async {
    if (!_listeningBroadcast) {
      _listeningBroadcast = true;
      _onBroadcast = () {
        unawaited(_refresh());
      };
      NearbyBroadcast.listen(_onBroadcast!);
    }
    await _refresh();
  }

  Future<void> publish(NearbyPresence presence) {
    localUserId = presence.userId;
    return store.publishPresence(presence);
  }

  Future<void> _refresh() async {
    final peers = [
      for (final item in await store.presence())
        if (item.userId != localUserId)
          PeerDevice(
            deviceId: item.deviceId,
            userId: item.userId,
            label: item.displayName,
          ),
    ];
    if (!_peers.isClosed) {
      _peers.add(peers);
    }
  }

  @override
  Future<void> stop() async {}

  Future<void> dispose() async {
    if (_onBroadcast != null) {
      NearbyBroadcast.unlisten(_onBroadcast!);
      _onBroadcast = null;
    }
    await stop();
    await _peers.close();
  }
}
