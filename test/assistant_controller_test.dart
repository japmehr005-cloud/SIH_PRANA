import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/features/assistant/application/assistant_conversation_controller.dart';
import 'package:aarogya/features/auth/data/local_account_repository.dart';
import 'package:aarogya/features/auth/data/local_account_service.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('assistant conversation follows the signed-in user', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final accounts = LocalAccountService(LocalAccountRepository(preferences));
    final userA = await accounts.register(
      displayName: 'User A',
      email: 'a@example.com',
      password: 'password-a',
    );
    final deps = createInMemoryDependencies(accounts: accounts);
    await deps.runtime.start();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dependenciesProvider.overrideWithValue(deps)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SizedBox.shrink(),
        ),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    container.read(assistantConversationProvider);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    final en = await AppLocalizations.delegate.load(const Locale('en'));
    await container
        .read(assistantConversationProvider.notifier)
        .ask(
          raw: 'Why did my status change?',
          session: deps.runtime.state,
          l10n: en,
        );
    expect(container.read(assistantConversationProvider).userId, userA.userId);
    expect(container.read(assistantConversationProvider).turns, isNotEmpty);

    await accounts.signOut();
    await accounts.register(
      displayName: 'User B',
      email: 'b@example.com',
      password: 'password-b',
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    expect(
      container.read(assistantConversationProvider).userId,
      isNot(userA.userId),
    );
    expect(container.read(assistantConversationProvider).turns, isEmpty);

    await accounts.signOut();
    await accounts.signIn(email: 'a@example.com', password: 'password-a');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    expect(container.read(assistantConversationProvider).userId, userA.userId);
    expect(
      container.read(assistantConversationProvider).turns.single.question,
      'Why did my status change?',
    );
  });
}
