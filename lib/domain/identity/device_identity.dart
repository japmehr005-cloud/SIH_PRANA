/// Stable app-level identity for a device and optional signed-in user.
///
/// [userId] is an account identifier. [deviceId] is a persisted app UUID.
/// Neither is a Bluetooth address. Do not treat this as a live mesh node.
final class DeviceIdentity {
  const DeviceIdentity({
    required this.deviceId,
    this.userId,
    this.label = 'Aarogya device',
  });

  final String deviceId;
  final String? userId;
  final String label;
}

abstract interface class DeviceIdentityStore {
  Future<DeviceIdentity> current();
  Future<DeviceIdentity> bindUser(String? userId);
}
