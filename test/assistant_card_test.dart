import 'dart:io';

import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/features/assistant/presentation/assistant_screen.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  EditableText.debugDeterministicCursor = true;

  testWidgets('assistant suggested questions and fall actions use live state', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;

    final deps = createInMemoryDependencies();
    await deps.runtime.start();
    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.highLoad,
      csv: File(DemonstrationCondition.highLoad.assetPath).readAsStringSync(),
      restingCsv: File(
        DemonstrationCondition.resting.assetPath,
      ).readAsStringSync(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dependenciesProvider.overrideWithValue(deps)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AssistantScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(en.pranaAssistant), findsWidgets);
    await tester.tap(find.text(en.assistantQuestionWhyStatus));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text(en.assistantHrHigherUsual), findsWidgets);

    await tester.enterText(
      find.byKey(PranaAssistantKeys.field),
      'What is my normal heart rate?',
    );
    await tester.tap(find.byKey(PranaAssistantKeys.ask));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text(en.assistantQuestionWhyStatus), findsWidgets);
    expect(find.textContaining('usual resting heart rate'), findsWidgets);

    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.fallImpact,
      csv: File(DemonstrationCondition.fallImpact.assetPath).readAsStringSync(),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(deps.runtime.state.fallStatus, FallStatus.awaitingConfirmation);
    expect(deps.runtime.state.latestPacket, isNull);
    expect(find.byKey(PranaAssistantKeys.iNeedHelp), findsOneWidget);

    await tester.tap(find.byKey(PranaAssistantKeys.iNeedHelp));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(deps.runtime.state.latestPacket, isNotNull);
    expect(deps.runtime.state.latestPacket!.eventType, 'possible_fall');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
