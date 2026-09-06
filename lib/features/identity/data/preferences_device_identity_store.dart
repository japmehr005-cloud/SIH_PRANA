import 'package:aarogya/domain/identity/device_identity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final class PreferencesDeviceIdentityStore implements DeviceIdentityStore {
  PreferencesDeviceIdentityStore(this._preferences);

  static const _deviceKey = 'aarogya.device_id';
  static const _userKey = 'aarogya.device_user_id';

  final SharedPreferences _preferences;

  @override
  Future<DeviceIdentity> current() async {
    var deviceId = _preferences.getString(_deviceKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await _preferences.setString(_deviceKey, deviceId);
    }
    return DeviceIdentity(
      deviceId: deviceId,
      userId: _preferences.getString(_userKey),
    );
  }

  @override
  Future<DeviceIdentity> bindUser(String? userId) async {
    final identity = await current();
    if (userId == null) {
      await _preferences.remove(_userKey);
    } else {
      await _preferences.setString(_userKey, userId);
    }
    return DeviceIdentity(deviceId: identity.deviceId, userId: userId);
  }
}
