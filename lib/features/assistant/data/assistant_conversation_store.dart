import 'dart:convert';

import 'package:aarogya/domain/assistant/assistant_turn.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AssistantConversationStore {
  static const prefix = 'aarogya.assistant.v1.';
  static const maxTurns = 20;

  Future<List<AssistantTurn>> load(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$prefix$userId');
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }
      return [
        for (final item in decoded)
          if (item is Map)
            AssistantTurn.fromJson(Map<String, Object?>.from(item)),
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<void> save(String userId, List<AssistantTurn> turns) async {
    final prefs = await SharedPreferences.getInstance();
    final clipped = turns.length <= maxTurns
        ? turns
        : turns.sublist(turns.length - maxTurns);
    await prefs.setString(
      '$prefix$userId',
      jsonEncode([for (final turn in clipped) turn.toJson()]),
    );
  }
}
