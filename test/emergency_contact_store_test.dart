import 'package:aarogya/features/identity/data/emergency_contact_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('emergency contacts stay isolated by account', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = EmergencyContactStore(preferences: prefs);

    await store.add(userId: 'user-a', name: 'Family', phone: '111');
    await store.add(userId: 'user-b', name: 'Neighbour', phone: '222');

    final a = await store.list('user-a');
    final b = await store.list('user-b');
    expect(a, hasLength(1));
    expect(b, hasLength(1));
    expect(a.single.name, 'Family');
    expect(b.single.name, 'Neighbour');
    expect(a.single.id, isNot(b.single.id));

    await store.remove(userId: 'user-a', id: a.single.id);
    expect(await store.list('user-a'), isEmpty);
    expect(await store.list('user-b'), hasLength(1));
  });
}
