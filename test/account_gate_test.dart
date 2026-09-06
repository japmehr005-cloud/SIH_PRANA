import 'package:aarogya/app/aarogya_app.dart';
import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/features/auth/data/local_account_repository.dart';
import 'package:aarogya/features/auth/data/local_account_service.dart';
import 'package:aarogya/features/auth/presentation/login_screen.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

Widget _loginApp(AarogyaDependencies deps) {
  return ProviderScope(
    overrides: [dependenciesProvider.overrideWithValue(deps)],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginScreen(),
    ),
  );
}

class _ConfiguredUnsignedAccounts implements AccountService {
  @override
  bool get isConfigured => true;

  @override
  AccountSession? get current => null;

  @override
  Stream<AccountSession?> watch() => Stream<AccountSession?>.value(null);

  @override
  Future<AccountSession?> restore() async => null;

  @override
  Future<AccountSession> signIn({
    required String email,
    required String password,
  }) {
    throw UnsupportedError('not used');
  }

  @override
  Future<AccountSession> register({
    required String displayName,
    required String email,
    required String password,
    String locale = 'en',
  }) {
    throw UnsupportedError('not used');
  }

  @override
  Future<AccountSession> continueAsDemonstrationUser() {
    throw UnsupportedError('not used');
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  EditableText.debugDeterministicCursor = true;

  test('configured unsigned sessions redirect to login', () {
    final unsigned = _ConfiguredUnsignedAccounts();
    expect(
      authRedirect(accounts: unsigned, path: AppPaths.home),
      AppPaths.login,
    );
    expect(authRedirect(accounts: unsigned, path: AppPaths.login), isNull);
    expect(authRedirect(accounts: unsigned, path: AppPaths.register), isNull);
    expect(authRedirect(accounts: const DisabledAccountService(), path: '/'), isNull);
  });

  testWidgets('disabled accounts still open Home without a login wall', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final deps = createInMemoryDependencies();
    await deps.runtime.start();
    final en = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dependenciesProvider.overrideWithValue(deps)],
        child: const AarogyaApp(),
      ),
    );
    await _pumpFrames(tester);

    expect(find.text(en.phaseNormal), findsWidgets);
    expect(find.text(en.signIn), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('configured unsigned session shows the public sign-in screen', (
    tester,
  ) async {
    final deps = createInMemoryDependencies(
      accounts: _ConfiguredUnsignedAccounts(),
    );
    final en = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(_loginApp(deps));

    expect(find.text(en.signIn), findsWidgets);
    expect(find.text(en.publicLandingBody), findsOneWidget);
    expect(find.text(en.phaseNormal), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('LocalAccountService without a session shows the login wall', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final accounts = LocalAccountService(LocalAccountRepository(preferences));
    final deps = createInMemoryDependencies(accounts: accounts);
    final en = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(_loginApp(deps));

    expect(find.text(en.signIn), findsWidgets);
    expect(find.text(en.continueAsDemoUser), findsOneWidget);
    expect(find.text(en.emailOrMobile), findsOneWidget);
    expect(find.text(en.phaseNormal), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
