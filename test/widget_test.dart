import 'package:aarogya/app/aarogya_app.dart';
import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  EditableText.debugDeterministicCursor = true;

  testWidgets('home screen renders Normal mode from real session state', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final deps = createInMemoryDependencies();
    await deps.runtime.start();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dependenciesProvider.overrideWithValue(deps)],
        child: const AarogyaApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.appTitle), findsWidgets);
    expect(find.text(l10n.phaseNormal), findsWidgets);
    expect(find.text(l10n.askPranaAssistant), findsWidgets);
    expect(find.text(l10n.openHealth), findsWidgets);
    await tester.tap(find.text(l10n.openHealth));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text(l10n.baselineNotReady), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
