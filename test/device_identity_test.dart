import 'package:aarogya/features/identity/data/memory_device_identity_store.dart';
import 'package:aarogya/features/identity/data/preferences_device_identity_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('memory store keeps a stable device id when binding a user', () async {
    final store = MemoryDeviceIdentityStore(deviceId: 'device-1');
    final first = await store.current();
    final bound = await store.bindUser('user-a');
    expect(first.deviceId, 'device-1');
    expect(bound.deviceId, 'device-1');
    expect(bound.userId, 'user-a');
  });

  test('preferences store persists the generated device id', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final firstStore = PreferencesDeviceIdentityStore(preferences);
    final first = await firstStore.current();
    expect(first.deviceId, isNotEmpty);

    final secondStore = PreferencesDeviceIdentityStore(preferences);
    final second = await secondStore.current();
    expect(second.deviceId, first.deviceId);

    await secondStore.bindUser('user-b');
    expect((await firstStore.current()).userId, 'user-b');
  });
}
