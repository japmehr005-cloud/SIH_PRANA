import 'dart:convert';

import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/nearby_presence.dart';
import 'package:aarogya/features/communication/data/nearby_broadcast.dart';
import 'package:aarogya/features/persistence/data/record_codecs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class NearbyInboxStore {
  NearbyInboxStore(this._preferences);

  static const inboxKey = 'aarogya.nearby.inbox';
  static const presenceKey = 'aarogya.nearby.presence';

  final SharedPreferences _preferences;

  Future<List<EmergencyPacket>> packets() async {
    await _preferences.reload();
    final raw = _preferences.getString(inboxKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    final now = DateTime.now().toUtc();
    return [
      for (final item in list)
        decodePacket(Map<String, dynamic>.from(item as Map)),
    ].where((packet) {
      return packet.expiresAt == null || !now.isAfter(packet.expiresAt!);
    }).toList();
  }

  Future<void> upsert(EmergencyPacket packet) async {
    final current = [for (final item in await packets()) item];
    current.removeWhere((item) => item.eventId == packet.eventId);
    current.add(packet);
    await _preferences.setString(
      inboxKey,
      jsonEncode([for (final item in current) encodePacket(item)]),
    );
    NearbyBroadcast.notify();
  }

  Future<List<NearbyPresence>> presence() async {
    await _preferences.reload();
    final raw = _preferences.getString(presenceKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    final cutoff = DateTime.now().toUtc().subtract(const Duration(minutes: 30));
    return [
      for (final item in list)
        NearbyPresence(
          deviceId: (item as Map)['deviceId'] as String,
          userId: item['userId'] as String,
          displayName: item['displayName'] as String? ?? 'PRANA user',
          updatedAt: DateTime.parse(item['updatedAt'] as String),
        ),
    ].where((item) => item.updatedAt.isAfter(cutoff)).toList();
  }

  Future<void> publishPresence(NearbyPresence record) async {
    final current = [
      for (final item in await presence())
        if (item.userId != record.userId) item,
      record,
    ];
    await _preferences.setString(
      presenceKey,
      jsonEncode([
        for (final item in current)
          {
            'deviceId': item.deviceId,
            'userId': item.userId,
            'displayName': item.displayName,
            'updatedAt': item.updatedAt.toUtc().toIso8601String(),
          },
      ]),
    );
    NearbyBroadcast.notify();
  }
}
