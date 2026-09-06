import 'dart:async';

import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/contracts/connectivity_service.dart';

final class InMemoryConnectivityService implements ConnectivityService {
  InMemoryConnectivityService([this._status = ConnectivityStatus.online]);

  ConnectivityStatus _status;
  final StreamController<ConnectivityStatus> _controller =
      StreamController<ConnectivityStatus>.broadcast();

  @override
  ConnectivityStatus get current => _status;

  @override
  Stream<ConnectivityStatus> watch() => _controller.stream;

  @override
  void setStatus(ConnectivityStatus status) {
    _status = status;
    _controller.add(status);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
