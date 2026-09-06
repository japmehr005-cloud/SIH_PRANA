import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';

final class RiskAssessment {
  const RiskAssessment({
    required this.level,
    required this.score,
    required this.reasons,
    required this.timestamp,
    required this.modelVersion,
    this.insufficientData = false,
    this.contextLabel,
    this.contextConfidence,
    this.usedTrainedModel = false,
    this.rulesScore = 0,
    this.modelContribution = 0,
    this.comparison,
  });

  factory RiskAssessment.insufficient({
    required DateTime timestamp,
    required String modelVersion,
  }) {
    return RiskAssessment(
      level: RiskLevel.low,
      score: 0,
      reasons: const [RiskReasonCode.insufficientHistory],
      timestamp: timestamp,
      modelVersion: modelVersion,
      insufficientData: true,
      usedTrainedModel: false,
    );
  }

  final RiskLevel level;
  final double score;
  final List<RiskReasonCode> reasons;
  final DateTime timestamp;
  final String modelVersion;
  final bool insufficientData;
  final String? contextLabel;
  final double? contextConfidence;
  final bool usedTrainedModel;
  final double rulesScore;
  final double modelContribution;
  final HealthComparison? comparison;
}
