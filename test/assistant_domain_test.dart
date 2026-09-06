import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/domain/assistant/assistant_intent.dart';
import 'package:aarogya/domain/assistant/assistant_reply.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/assistant/domain/assistant_composer.dart';
import 'package:aarogya/features/assistant/domain/assistant_intent_router.dart';
import 'package:aarogya/features/assistant/domain/assistant_situation_compiler.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations en;
  late AppLocalizations hi;
  final now = DateTime.utc(2026, 9, 7, 6, 30);

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
    hi = await AppLocalizations.delegate.load(const Locale('hi'));
  });

  test('compiler copies comparison and guidance without new risk math', () {
    final state = _session(
      now: now,
      currentHr: 84,
      usualHr: 66,
      context: 'elevated_load',
      reasons: const [RiskReasonCode.hrAboveBaseline],
      level: RiskLevel.high,
    );
    final situation = AssistantSituationCompiler.compile(state);
    expect(situation.baselineReady, isTrue);
    expect(situation.currentHeartRate, 84);
    expect(situation.usualHeartRate, 66);
    expect(situation.heartRateHigherThanUsual, isTrue);
    expect(situation.contextLabel, 'elevated_load');
    expect(situation.riskReasons, contains(RiskReasonCode.hrAboveBaseline));
    expect(situation.placeLabel, 'Tudikhel / Ratna Park');
    expect(situation.distanceMeters, 1895);
    expect(situation.compassLabel, 'SW');
    expect(situation.usesDemonstrationData, isTrue);
  });

  test('whatChangedFromUsual mentions higher HR, not a diagnosis', () {
    final resting = AssistantComposer.compose(
      intent: AssistantIntent.whatChangedFromUsual,
      situation: AssistantSituationCompiler.compile(
        _session(now: now, currentHr: 66, usualHr: 66, context: 'rest'),
      ),
      l10n: en,
    );
    final loaded = AssistantComposer.compose(
      intent: AssistantIntent.whatChangedFromUsual,
      situation: AssistantSituationCompiler.compile(
        _session(
          now: now,
          currentHr: 84,
          usualHr: 66,
          context: 'elevated_load',
          reasons: const [RiskReasonCode.hrAboveBaseline],
          level: RiskLevel.high,
        ),
      ),
      l10n: en,
    );

    expect(resting.lines, contains(en.assistantHrSimilarUsual));
    expect(resting.lines, isNot(contains(en.assistantContextElevated)));
    expect(loaded.lines, contains(en.assistantHrHigherUsual));
    expect(loaded.lines.join(' '), contains('84'));
    expect(loaded.lines.join(' '), contains('66'));
    _expectPublicLanguage(loaded);
    _expectNoDiagnosis(loaded);
  });

  test('elevated-load context appears only for that label', () {
    final rest = AssistantComposer.compose(
      intent: AssistantIntent.whatChangedFromUsual,
      situation: AssistantSituationCompiler.compile(
        _session(now: now, currentHr: 66, usualHr: 66, context: 'rest'),
      ),
      l10n: en,
    );
    final elevated = AssistantComposer.compose(
      intent: AssistantIntent.whatChangedFromUsual,
      situation: AssistantSituationCompiler.compile(
        _session(
          now: now,
          currentHr: 84,
          usualHr: 66,
          context: 'elevated_load',
        ),
      ),
      l10n: en,
    );
    expect(rest.lines, isNot(contains(en.assistantContextElevated)));
    expect(rest.lines, contains(en.assistantContextRest));
    expect(elevated.lines, contains(en.assistantContextElevated));
  });

  test('typed I fell does not invent a fall', () {
    final match = AssistantIntentRouter.route('I fell', l10n: en);
    expect(match.intent, AssistantIntent.briefing);
    expect(match.unrecognized, isTrue);

    final reply = AssistantComposer.compose(
      intent: match.intent,
      situation: AssistantSituationCompiler.compile(
        _session(now: now, currentHr: 66, usualHr: 66, context: 'rest'),
      ),
      l10n: en,
      unrecognized: match.unrecognized,
    );
    expect(reply.lines, contains(en.assistantInsufficient));
    expect(reply.lines, isNot(contains(en.assistantFallExplain)));
    expect(reply.showFallActions, isFalse);
    expect(reply.priority, isNot(AssistantReplyPriority.fall));
  });

  test('awaiting fall asks if the user is safe', () {
    final reply = AssistantComposer.compose(
      intent: AssistantIntent.briefing,
      situation: AssistantSituationCompiler.compile(
        _session(
          now: now,
          currentHr: 90,
          usualHr: 66,
          context: 'rest',
          fallStatus: FallStatus.awaitingConfirmation,
        ),
      ),
      l10n: en,
    );
    expect(reply.lines, contains(en.assistantFallExplain));
    expect(reply.lines, contains(en.assistantConfirmSafe));
    expect(reply.showFallActions, isTrue);
    expect(reply.priority, AssistantReplyPriority.fall);
  });

  test('disaster guidance and bearing stay grounded', () {
    final state = _session(
      now: now,
      currentHr: 84,
      usualHr: 66,
      context: 'elevated_load',
      phase: EmergencyPhase.disasterActive,
      disasterType: DisasterType.flood,
      connectivity: ConnectivityStatus.limited,
    );
    final actions = AssistantComposer.compose(
      intent: AssistantIntent.whatShouldIDo,
      situation: AssistantSituationCompiler.compile(state),
      l10n: en,
    );
    final where = AssistantComposer.compose(
      intent: AssistantIntent.whereToGo,
      situation: AssistantSituationCompiler.compile(state),
      l10n: en,
    );

    expect(actions.lines, contains(en.floodAction));
    expect(actions.lines, contains(en.floodAvoidWater));
    expect(actions.lines, contains(en.assistantAssistanceLimited));
    expect(
      where.lines.join(' '),
      contains('Tudikhel / Ratna Park'),
    );
    expect(where.lines.join(' '), contains('1895'));
    expect(where.lines.join(' '), contains(en.compassSouthWest));
    expect(actions.lines.join(' ').toLowerCase(), isNot(contains('route')));
    _expectPublicLanguage(actions);
    _expectPublicLanguage(where);
  });

  test('unknown location stays unavailable', () {
    final state = _session(
      now: now,
      currentHr: 70,
      usualHr: 66,
      context: 'rest',
      phase: EmergencyPhase.disasterActive,
      disasterType: DisasterType.flood,
      includeGuidance: false,
      connectivity: ConnectivityStatus.offline,
    );
    final where = AssistantComposer.compose(
      intent: AssistantIntent.whereToGo,
      situation: AssistantSituationCompiler.compile(state),
      l10n: en,
    );
    expect(where.lines, contains(en.assistantNoSaferPlace));
    expect(where.lines.join(' '), isNot(contains('Tudikhel')));
    _expectPublicLanguage(where);
  });

  test('public language omits engines, ids, and confidence', () {
    final state = _session(
      now: now,
      currentHr: 84,
      usualHr: 66,
      context: 'elevated_load',
      phase: EmergencyPhase.survival,
      disasterType: DisasterType.flood,
      fallStatus: FallStatus.awaitingConfirmation,
      includePacket: true,
    );
    for (final locale in [en, hi]) {
      final reply = AssistantComposer.compose(
        intent: AssistantIntent.emergencyWhatToDo,
        situation: AssistantSituationCompiler.compile(state),
        l10n: locale,
      );
      _expectPublicLanguage(reply);
      expect(reply.lines.join(' '), isNot(contains('evt-hidden-id')));
    }
  });

  test('free-text health and location questions route correctly', () {
    expect(
      AssistantIntentRouter.route('Why is my heart rate high?').intent,
      AssistantIntent.whyStatusChanged,
    );
    expect(
      AssistantIntentRouter.route('What is my normal heart rate?').intent,
      AssistantIntent.usualReadings,
    );
    expect(
      AssistantIntentRouter.route('How can I get help?').intent,
      AssistantIntent.whatIfINeedHelp,
    );
    final usual = AssistantComposer.compose(
      intent: AssistantIntent.usualReadings,
      situation: AssistantSituationCompiler.compile(
        _session(now: now, currentHr: 66, usualHr: 66, context: 'rest'),
      ),
      l10n: en,
    );
    expect(usual.lines, contains(en.assistantUsualHr('66')));
  });

  test('suggested chips include location in both modes', () {
    expect(
      AssistantIntentRouter.chipOrder(emergencyFirst: false),
      contains(AssistantIntent.whereToGo),
    );
    expect(
      AssistantIntentRouter.chipOrder(emergencyFirst: true),
      contains(AssistantIntent.whereToGo),
    );
  });

  test('suggested questions and Hindi phrases route to the same intents', () {
    expect(
      AssistantIntentRouter.route(en.assistantQuestionWhyStatus, l10n: en).intent,
      AssistantIntent.whyStatusChanged,
    );
    expect(
      AssistantIntentRouter.route(hi.assistantQuestionWhereToGo, l10n: hi).intent,
      AssistantIntent.whereToGo,
    );
    expect(
      AssistantIntentRouter.route('मुझे क्या करना चाहिए').intent,
      AssistantIntent.whatShouldIDo,
    );
  });
}

AppSessionState _session({
  required DateTime now,
  required double currentHr,
  required double usualHr,
  required String context,
  List<RiskReasonCode> reasons = const [],
  RiskLevel level = RiskLevel.low,
  EmergencyPhase phase = EmergencyPhase.normal,
  DisasterType? disasterType,
  FallStatus fallStatus = FallStatus.none,
  ConnectivityStatus connectivity = ConnectivityStatus.online,
  bool includeGuidance = true,
  bool includePacket = false,
}) {
  final sample = SensorSample(
    timestamp: now,
    heartRateBpm: currentHr,
    spo2Percent: context == 'elevated_load' ? 93 : 98,
    isSimulation: true,
    sourceKind: SensorSourceKind.simulation,
  );
  final baseline = PersonalBaseline(
    version: 'baseline-v1',
    sampleCount: 12,
    computedAt: now,
    restingHeartRate: MetricRange(low: 60, high: 72, median: usualHr),
    spo2: const MetricRange(low: 96, high: 99, median: 98),
  );
  final comparison = HealthComparison(
    currentHeartRate: currentHr,
    usualHeartRate: usualHr,
    currentSpo2: sample.spo2Percent,
    usualSpo2: 98,
    windowHeartRateMean: currentHr,
    recentHeartRates: [usualHr, currentHr],
    sensorSourceKind: SensorSourceKind.simulation,
  );
  return AppSessionState(
    emergency: EmergencySnapshot(
      phase: phase,
      updatedAt: now,
      disasterType: disasterType,
    ),
    connectivity: connectivity,
    ready: true,
    currentSample: sample,
    recentSamples: [sample],
    baseline: baseline,
    risk: RiskAssessment(
      level: level,
      score: level == RiskLevel.low ? 8 : 48,
      reasons: reasons,
      timestamp: now,
      modelVersion: 'physio-context-v1',
      contextLabel: context,
      contextConfidence: 0.91,
      usedTrainedModel: true,
      rulesScore: 40,
      modelContribution: 16,
      comparison: comparison,
    ),
    fallStatus: fallStatus,
    simulationActive: true,
    engineVersion: 'physio-context-v1',
    deviceLocation: includeGuidance
        ? DeviceLocation(
            latitude: 27.717,
            longitude: 85.324,
            capturedAt: now,
            source: LocationSource.demonstration,
          )
        : null,
    guidance: includeGuidance
        ? SaferLocationGuidance(
            current: DeviceLocation(
              latitude: 27.717,
              longitude: 85.324,
              capturedAt: now,
              source: LocationSource.demonstration,
            ),
            place: const SaferPlace(
              id: 'tudikhel',
              label: 'Tudikhel / Ratna Park',
              location: GeoPoint(latitude: 27.705, longitude: 85.315),
            ),
            distanceMeters: 1895,
            bearingDegrees: 225,
            insideHazard: true,
            hazardLabel: 'Bagmati corridor',
            sourceNote: 'bundled-geojson',
            isDemonstrationDataset: true,
            catalogId: 'kathmandu',
          )
        : null,
    latestPacket: includePacket
        ? EmergencyPacket(
            eventId: 'evt-hidden-id',
            timestamp: now,
            eventType: 'possible_fall',
            riskLevel: RiskLevel.critical,
            fallStatus: FallStatus.awaitingConfirmation,
            state: PacketState.stored,
            connectivityAtCreation: connectivity,
          )
        : null,
  );
}

void _expectPublicLanguage(AssistantReply reply) {
  final text = '${reply.headline}\n${reply.lines.join('\n')}';
  expect(text, isNot(contains('Aarogya')));
  expect(text, isNot(contains('आरोग्य')));
  expect(text, isNot(contains('physio-context')));
  expect(text, isNot(contains('SisFall')));
  expect(text.toLowerCase(), isNot(contains('confidence')));
  expect(text, isNot(contains('evt-hidden-id')));
  expect(text, isNot(contains('rulesScore')));
}

void _expectNoDiagnosis(AssistantReply reply) {
  final text = reply.lines.join(' ').toLowerCase();
  expect(text, isNot(contains('heart attack')));
  expect(text, isNot(contains('dehydrated')));
  expect(text, isNot(contains('you have a medical condition')));
  expect(text, isNot(contains('will save your life')));
}
