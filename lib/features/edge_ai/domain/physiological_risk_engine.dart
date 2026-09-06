import 'package:aarogya/domain/contracts/inference_engine.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';

final class PhysiologicalRiskEngine {
  const PhysiologicalRiskEngine();

  static const String version = 'physio-risk-v1';

  RiskAssessment assess(InferenceInput input) {
    final reasons = <RiskReasonCode>[];
    var rulesScore = 0.0;
    var usableSignals = 0;

    final baseline = input.baseline;
    final current = input.current;
    final hr = current.heartRateBpm;
    final spo2 = current.spo2Percent;
    final exertion = input.physioContext == 'exertion';
    final moving =
        current.movement == MovementState.high ||
        current.movement == MovementState.normal;

    if (baseline == null || !baseline.isEstablished) {
      if (!input.phase.isEmergencyActive) {
        return RiskAssessment.insufficient(
          timestamp: current.timestamp,
          modelVersion: version,
        );
      }
      reasons.add(RiskReasonCode.limitedSensors);
    }

    if (hr != null && baseline?.restingHeartRate != null) {
      usableSignals += 1;
      final range = baseline!.restingHeartRate!;
      var hrBump = 0.0;
      if (hr > range.high + 15) {
        hrBump = 28;
      } else if (hr > range.high + 5) {
        hrBump = 14;
      }
      if (hrBump > 0 && exertion && moving) {
        hrBump *= 0.5;
      }
      if (hrBump > 0) {
        rulesScore += hrBump;
        reasons.add(RiskReasonCode.hrAboveBaseline);
      }
    } else if (hr != null) {
      usableSignals += 1;
    }

    if (spo2 != null && baseline?.spo2 != null) {
      usableSignals += 1;
      if (spo2 < baseline!.spo2!.low - 2) {
        rulesScore += 22;
        reasons.add(RiskReasonCode.spo2BelowBaseline);
      }
    } else if (spo2 != null) {
      usableSignals += 1;
    }

    if (hr != null && current.movement?.isResting == true && hr >= 100) {
      rulesScore += 18;
      reasons.add(RiskReasonCode.highHrLowMovement);
    }

    if (_prolongedHighActivity(input.recent)) {
      rulesScore += 12;
      reasons.add(RiskReasonCode.prolongedActivity);
    }

    if (input.phase.isEmergencyActive && input.disasterType != null) {
      rulesScore += 10;
      reasons.add(RiskReasonCode.environmentalStress);
    }

    final modelContribution = _modelContribution(input, reasons);
    final canUseModel =
        (baseline != null && baseline.isEstablished) ||
        input.phase.isEmergencyActive;

    if (usableSignals == 0 &&
        reasons.every((code) => code == RiskReasonCode.limitedSensors)) {
      return RiskAssessment.insufficient(
        timestamp: current.timestamp,
        modelVersion: version,
      );
    }

    final appliedModel = canUseModel ? modelContribution : 0.0;
    final score = (rulesScore + appliedModel).clamp(0, 100).toDouble();

    return RiskAssessment(
      level: _levelFor(score),
      score: score,
      reasons: reasons,
      timestamp: current.timestamp,
      modelVersion: version,
      rulesScore: rulesScore,
      modelContribution: appliedModel,
    );
  }

  double _modelContribution(
    InferenceInput input,
    List<RiskReasonCode> reasons,
  ) {
    final context = input.physioContext;
    final probability = input.nonRestProbability;
    if (context == null || probability == null) {
      return 0;
    }

    final moving =
        input.current.movement == MovementState.high ||
        input.current.movement == MovementState.normal;
    if (context == 'exertion' && moving) {
      reasons.add(RiskReasonCode.modelExertionContext);
      return 8 * probability;
    }
    if (context == 'elevated_load' && probability >= 0.35) {
      reasons.add(RiskReasonCode.modelElevatedLoadContext);
      return 16 * probability;
    }
    if (context != 'rest' && probability >= 0.55) {
      return 12 * probability;
    }
    return 0;
  }

  bool _prolongedHighActivity(List<SensorSample> recent) {
    final high = recent.where((sample) {
      return sample.movement == MovementState.high;
    }).length;
    return high >= 6;
  }

  RiskLevel _levelFor(double score) {
    if (score >= 75) {
      return RiskLevel.critical;
    }
    if (score >= 50) {
      return RiskLevel.high;
    }
    if (score >= 25) {
      return RiskLevel.moderate;
    }
    return RiskLevel.low;
  }
}
