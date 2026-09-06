import 'package:aarogya/domain/contracts/inference_engine.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';
import 'package:aarogya/features/edge_ai/domain/physiological_risk_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

void main() {
  const engine = PhysiologicalRiskEngine();
  final now = DateTime.utc(2026, 9, 6);
  final baseline = PersonalBaseline(
    version: PersonalBaselinePolicy.version,
    sampleCount: 12,
    computedAt: now,
    restingHeartRate: const MetricRange(low: 62, high: 72, median: 67),
    spo2: const MetricRange(low: 96, high: 99, median: 98),
  );

  test('returns insufficient data when history is missing in normal mode', () {
    final assessment = engine.assess(
      InferenceInput(
        current: sample(at: now, hr: 70, spo2: 98, movement: MovementState.low),
        recent: const [],
        phase: EmergencyPhase.normal,
      ),
    );
    expect(assessment.insufficientData, isTrue);
    expect(assessment.reasons, contains(RiskReasonCode.insufficientHistory));
  });

  test('scores a large resting heart-rate deviation as elevated risk', () {
    final assessment = engine.assess(
      InferenceInput(
        current: sample(
          at: now,
          hr: 116,
          spo2: 93,
          movement: MovementState.none,
        ),
        recent: const [],
        phase: EmergencyPhase.survival,
        baseline: baseline,
        disasterType: DisasterType.flood,
      ),
    );
    expect(assessment.insufficientData, isFalse);
    expect(assessment.level.rank >= RiskLevel.high.rank, isTrue);
    expect(assessment.reasons, contains(RiskReasonCode.hrAboveBaseline));
    expect(assessment.reasons, contains(RiskReasonCode.spo2BelowBaseline));
  });

  test('does not treat missing SpO2 as zero', () {
    final assessment = engine.assess(
      InferenceInput(
        current: sample(
          at: now,
          hr: 68,
          spo2: null,
          movement: MovementState.low,
        ),
        recent: const [],
        phase: EmergencyPhase.normal,
        baseline: baseline,
      ),
    );
    expect(
      assessment.reasons,
      isNot(contains(RiskReasonCode.spo2BelowBaseline)),
    );
    expect(assessment.level, RiskLevel.low);
  });

  test('exertion context reduces heart-rate pile-on when movement is high', () {
    final withoutContext = engine.assess(
      InferenceInput(
        current: sample(
          at: now,
          hr: 116,
          spo2: 98,
          movement: MovementState.high,
        ),
        recent: const [],
        phase: EmergencyPhase.survival,
        baseline: baseline,
        disasterType: DisasterType.flood,
      ),
    );
    final withExertion = engine.assess(
      InferenceInput(
        current: sample(
          at: now,
          hr: 116,
          spo2: 98,
          movement: MovementState.high,
        ),
        recent: const [],
        phase: EmergencyPhase.survival,
        baseline: baseline,
        disasterType: DisasterType.flood,
        physioContext: 'exertion',
        contextConfidence: 0.8,
        nonRestProbability: 0.8,
      ),
    );
    expect(withExertion.score, lessThan(withoutContext.score));
    expect(withExertion.reasons, contains(RiskReasonCode.hrAboveBaseline));
    expect(withExertion.reasons, contains(RiskReasonCode.modelExertionContext));
    expect(withExertion.modelContribution, greaterThan(0));
  });

  test('elevated-load context is one input to the risk score', () {
    final assessment = engine.assess(
      InferenceInput(
        current: sample(at: now, hr: 70, spo2: 98, movement: MovementState.low),
        recent: const [],
        phase: EmergencyPhase.normal,
        baseline: baseline,
        physioContext: 'elevated_load',
        contextConfidence: 0.7,
        nonRestProbability: 0.7,
      ),
    );
    expect(
      assessment.reasons,
      contains(RiskReasonCode.modelElevatedLoadContext),
    );
    expect(assessment.modelContribution, closeTo(11.2, 0.01));
    expect(assessment.rulesScore, 0);
  });
}
