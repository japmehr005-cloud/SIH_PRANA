enum ConnectivityStatus { online, offline, limited, unknown }

extension ConnectivityStatusX on ConnectivityStatus {
  bool get canTransmit => this == ConnectivityStatus.online;
}
