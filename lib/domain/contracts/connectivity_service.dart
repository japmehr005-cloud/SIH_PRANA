import 'package:aarogya/domain/communication/connectivity_status.dart';

abstract interface class ConnectivityService {
  ConnectivityStatus get current;
  Stream<ConnectivityStatus> watch();
  void setStatus(ConnectivityStatus status);
}
