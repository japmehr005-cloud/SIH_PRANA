import 'dart:convert';

import 'package:aarogya/domain/identity/emergency_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final class EmergencyContactStore {
  EmergencyContactStore({required this._preferences});

  final SharedPreferences _preferences;
  static const _uuid = Uuid();

  String _key(String userId) => 'aarogya.contacts.v1.$userId';

  Future<List<EmergencyContact>> list(String userId) async {
    final raw = _preferences.getString(_key(userId));
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in decoded)
        EmergencyContact(
          id: (item as Map)['id'] as String,
          name: item['name'] as String,
          phone: item['phone'] as String,
        ),
    ];
  }

  Future<EmergencyContact> add({
    required String userId,
    required String name,
    required String phone,
  }) async {
    final contacts = [...await list(userId)];
    final created = EmergencyContact(
      id: _uuid.v4(),
      name: name.trim(),
      phone: phone.trim(),
    );
    contacts.add(created);
    await _save(userId, contacts);
    return created;
  }

  Future<void> remove({required String userId, required String id}) async {
    final contacts = [
      for (final contact in await list(userId))
        if (contact.id != id) contact,
    ];
    await _save(userId, contacts);
  }

  Future<void> _save(String userId, List<EmergencyContact> contacts) {
    return _preferences.setString(
      _key(userId),
      jsonEncode([
        for (final contact in contacts)
          {'id': contact.id, 'name': contact.name, 'phone': contact.phone},
      ]),
    );
  }
}
