import 'package:aarogya/domain/contracts/fall_detector.dart';
import 'package:aarogya/domain/contracts/inference_engine.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';
import 'package:aarogya/features/edge_ai/domain/fall_detection_engine.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';
import 'package:aarogya/features/edge_ai/domain/physiological_risk_engine.dart';

final class LocalInferenceEngine implements InferenceEngine {
  const LocalInferenceEngine({
    this.fallEngine = const FallDetectionEngine(),
    this.riskEngine = const PhysiologicalRiskEngine(),
    this.contextModel,
  });

  final FallDetector fallEngine;
  final PhysiologicalRiskEngine riskEngine;
  final PhysioContextModel? contextModel;

  @override
  String get name => 'local-inference';

  @override
  String get version => contextModel?.version ?? 'local-v1';

  @override
  InferenceResult infer(InferenceInput input) {
    final fallStatus = fallEngine.detect([...input.recent, input.current]);
    final prediction = contextModel?.predict(input);
    final assessed = riskEngine.assess(
      InferenceInput(
        current: input.current,
        recent: input.recent,
        phase: input.phase,
        baseline: input.baseline,
        disasterType: input.disasterType,
        physioContext: prediction?.context,
        contextConfidence: prediction?.confidence,
        nonRestProbability: prediction?.nonRestProbability,
      ),
    );
    final mergedReasons = [
      ...assessed.reasons,
      if (fallStatus == FallStatus.possible)
        RiskReasonCode.possibleFallSequence,
    ];
    var level = assessed.level;
    if (fallStatus == FallStatus.possible && level.rank < RiskLevel.high.rank) {
      level = RiskLevel.high;
    }
    final comparison = HealthComparison.fromWindow(
      current: input.current,
      recent: input.recent,
      baseline: input.baseline,
      rulesScore: assessed.rulesScore,
      modelContribution: assessed.modelContribution,
    );
    return InferenceResult(
      risk: RiskAssessment(
        level: level,
        score: assessed.score,
        reasons: mergedReasons,
        timestamp: assessed.timestamp,
        modelVersion: version,
        insufficientData:
            assessed.insufficientData &&
            fallStatus == FallStatus.none &&
            prediction == null,
        contextLabel: prediction?.context,
        contextConfidence: prediction?.confidence,
        usedTrainedModel: prediction != null,
        rulesScore: assessed.rulesScore,
        modelContribution: assessed.modelContribution,
        comparison: comparison,
      ),
      fallStatus: fallStatus,
      engineName: name,
      engineVersion: version,
      fallDetectionMode: fallEngine.mode,
    );
  }
}
