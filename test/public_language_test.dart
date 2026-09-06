import 'dart:convert';
import 'dart:io';

import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/inference_status_rows.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('public English and Hindi copy does not use the old product name', () {
    final english = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
        as Map<String, dynamic>;
    final hindi = jsonDecode(File('lib/l10n/app_hi.arb').readAsStringSync())
        as Map<String, dynamic>;
    for (final entry in english.entries) {
      if (entry.key.startsWith('@')) {
        continue;
      }
      expect(
        entry.value,
        isNot(contains('Aarogya')),
        reason: entry.key,
      );
    }
    for (final entry in hindi.entries) {
      if (entry.key.startsWith('@')) {
        continue;
      }
      expect(entry.value, isNot(contains('आरोग्य')), reason: entry.key);
      expect(entry.value, isNot(contains('Aarogya')), reason: entry.key);
    }
  });

  testWidgets('public health rows hide engine and rule-score jargon', (
    tester,
  ) async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final now = DateTime.utc(2026, 9, 6, 12);
    final state = AppSessionState(
      emergency: EmergencySnapshot.normal(now),
      connectivity: ConnectivityStatus.online,
      ready: true,
      engineVersion: 'physio-context-v1',
      risk: RiskAssessment(
        level: RiskLevel.moderate,
        score: 40,
        reasons: const [],
        timestamp: now,
        modelVersion: 'physio-context-v1',
        contextLabel: 'rest',
        contextConfidence: 0.8,
        usedTrainedModel: true,
        rulesScore: 60,
        modelContribution: 16,
        comparison: const HealthComparison(
          currentHeartRate: 70,
          usualHeartRate: 66,
          currentSpo2: 98,
          usualSpo2: 98,
          windowHeartRateMean: 69,
          rulesScore: 60,
          modelContribution: 16,
          sensorSourceKind: SensorSourceKind.simulation,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HealthAssessmentRows(state: state),
          ),
        ),
      ),
    );

    expect(find.text(en.healthAssessment), findsOneWidget);
    expect(find.text(en.assessmentConfidence), findsOneWidget);
    expect(find.text(en.sensorSourceSimulation), findsOneWidget);
    expect(find.text(en.fallCheckSimulated), findsOneWidget);
    expect(find.text(en.engineVersion), findsNothing);
    expect(find.text('physio-context-v1'), findsNothing);
    expect(find.text(en.riskInputs), findsNothing);
    expect(find.text(en.riskInputsValue('60', '16')), findsNothing);
  });

  testWidgets('technical information shows engine version for evaluators', (
    tester,
  ) async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final now = DateTime.utc(2026, 9, 6, 12);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TechnicalInformationRows(
            state: AppSessionState(
              emergency: EmergencySnapshot.normal(now),
              connectivity: ConnectivityStatus.online,
              ready: true,
              engineVersion: 'physio-context-v1',
            ),
            userId: 'user-a',
            deviceId: 'device-a',
          ),
        ),
      ),
    );

    expect(find.text(en.engineVersion), findsOneWidget);
    expect(find.text('physio-context-v1'), findsOneWidget);
    expect(find.text('user-a'), findsOneWidget);
    expect(find.text('device-a'), findsOneWidget);
  });
}
