import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';

final class InferenceInput {
  const InferenceInput({
    required this.current,
    required this.recent,
    required this.phase,
    this.baseline,
    this.disasterType,
    this.physioContext,
    this.contextConfidence,
    this.nonRestProbability,
  });

  final SensorSample current;
  final List<SensorSample> recent;
  final EmergencyPhase phase;
  final PersonalBaseline? baseline;
  final DisasterType? disasterType;
  final String? physioContext;
  final double? contextConfidence;
  final double? nonRestProbability;
}

final class InferenceResult {
  const InferenceResult({
    required this.risk,
    required this.fallStatus,
    required this.engineName,
    required this.engineVersion,
    this.fallDetectionMode = 'simulated-sequence',
  });

  final RiskAssessment risk;
  final FallStatus fallStatus;
  final String engineName;
  final String engineVersion;
  final String fallDetectionMode;
}

abstract interface class InferenceEngine {
  String get name;
  String get version;
  InferenceResult infer(InferenceInput input);
}
