import 'package:aarogya/domain/identity/device_identity.dart';
import 'package:uuid/uuid.dart';

final class MemoryDeviceIdentityStore implements DeviceIdentityStore {
  MemoryDeviceIdentityStore({String? deviceId})
    : _identity = DeviceIdentity(deviceId: deviceId ?? const Uuid().v4());

  DeviceIdentity _identity;

  @override
  Future<DeviceIdentity> current() async => _identity;

  @override
  Future<DeviceIdentity> bindUser(String? userId) async {
    _identity = DeviceIdentity(
      deviceId: _identity.deviceId,
      userId: userId,
      label: _identity.label,
    );
    return _identity;
  }
}
