import 'package:aarogya/app/aarogya_app.dart';
import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  EditableText.debugDeterministicCursor = true;

  testWidgets(
    'home reflects a real flood warning and language switch keeps the phase',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final deps = createInMemoryDependencies();
      await deps.runtime.start();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [dependenciesProvider.overrideWithValue(deps)],
          child: const AarogyaApp(),
        ),
      );
      await _pumpFrames(tester);

      final en = await AppLocalizations.delegate.load(const Locale('en'));
      final hi = await AppLocalizations.delegate.load(const Locale('hi'));

      expect(find.text(en.phaseNormal), findsWidgets);

      await deps.runtime.activateOfficialFlood();
      await _pumpFrames(tester);

      expect(deps.runtime.state.emergency.phase, EmergencyPhase.disasterAlert);
      expect(find.text(en.floodWarningIssued), findsWidgets);
      expect(find.text(en.situationEmergency), findsWidgets);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AarogyaApp)),
      );
      await container
          .read(localeControllerProvider.notifier)
          .setLocale(const Locale('hi'));
      await _pumpFrames(tester);

      expect(deps.runtime.state.emergency.phase, EmergencyPhase.disasterAlert);
      expect(find.text(hi.floodWarningIssued), findsWidgets);
      expect(find.text(en.floodWarningIssued), findsNothing);

      await deps.runtime.resetDemo();
      await _pumpFrames(tester);
      expect(deps.runtime.state.emergency.phase, EmergencyPhase.normal);
      expect(find.text(hi.phaseNormal), findsWidgets);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}
