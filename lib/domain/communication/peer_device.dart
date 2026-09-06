import 'package:aarogya/domain/communication/emergency_packet.dart';

/// A nearby device that could later receive an emergency packet.
///
/// This is an identity record only. It does not imply Bluetooth or Wi-Fi Direct.
final class PeerDevice {
  const PeerDevice({required this.deviceId, this.label, this.userId});

  final String deviceId;
  final String? label;
  final String? userId;
}

/// Discovers nearby peers. Browser demo does not start a radio.
abstract interface class PeerDiscovery {
  Stream<List<PeerDevice>> watch();
  Future<void> start();
  Future<void> stop();
}

/// Sends a packet to one peer over a local radio. Not implemented on web.
///
/// Store-and-forward remains the existing StoreAndForwardService.
abstract interface class LocalTransfer {
  Future<bool> send({
    required EmergencyPacket packet,
    required PeerDevice peer,
  });
}

final class UnsupportedPeerDiscovery implements PeerDiscovery {
  const UnsupportedPeerDiscovery();

  @override
  Stream<List<PeerDevice>> watch() => Stream<List<PeerDevice>>.value(const []);

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}
}

final class UnsupportedLocalTransfer implements LocalTransfer {
  const UnsupportedLocalTransfer();

  @override
  Future<bool> send({
    required EmergencyPacket packet,
    required PeerDevice peer,
  }) async {
    return false;
  }
}
