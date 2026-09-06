import 'package:aarogya/domain/assistant/assistant_turn.dart';
import 'package:aarogya/features/assistant/data/assistant_conversation_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('assistant conversations stay scoped to the current user', () async {
    SharedPreferences.setMockInitialValues({});
    final store = AssistantConversationStore();
    final turn = AssistantTurn(
      question: 'Why did my status change?',
      headline: 'Your current health',
      lines: const ['Your recent heart rate is higher than your usual resting pattern.'],
      askedAt: DateTime.utc(2026, 9, 7),
    );
    await store.save('user-a', [turn]);
    expect(await store.load('user-b'), isEmpty);
    final loaded = await store.load('user-a');
    expect(loaded, hasLength(1));
    expect(loaded.single.question, turn.question);
    expect(loaded.single.lines, turn.lines);
  });
}
