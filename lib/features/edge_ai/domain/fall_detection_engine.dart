import 'package:aarogya/domain/contracts/fall_detector.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

/// Deterministic sequence detector. Versioned for later model replacement.
final class FallDetectionEngine implements FallDetector {
  const FallDetectionEngine();

  @override
  String get version => engineVersion;

  @override
  String get mode => detectorMode;

  static const String engineVersion = 'fall-seq-v1';

  /// Honest until a SisFall-trained model implements [FallDetector].
  static const String detectorMode = 'simulated-sequence';

  /// Acceleration spike threshold in m/s^2. Documented prototype threshold.
  static const double spikeThreshold = 24;
  static const double impactDrop = 8;
  static const double orientationThreshold = 0.7;
  static const int inactivityWindow = 3;

  @override
  FallStatus detect(List<SensorSample> window) {
    if (window.length < 4) {
      return FallStatus.none;
    }

    final spikeIndex = window.indexWhere((sample) {
      return (sample.accelMagnitude ?? 0) >= spikeThreshold;
    });
    if (spikeIndex < 0 || spikeIndex >= window.length - 2) {
      return FallStatus.none;
    }

    final afterSpike = window.sublist(spikeIndex);
    if (_looksLikeContinuedActivity(afterSpike)) {
      return FallStatus.none;
    }

    final hasImpact = afterSpike.any((sample) {
      final magnitude = sample.accelMagnitude ?? 0;
      return magnitude <= impactDrop;
    });
    final hasOrientation = afterSpike.any((sample) {
      return (sample.orientationDelta ?? 0) >= orientationThreshold;
    });
    final tail = afterSpike.length <= inactivityWindow
        ? afterSpike
        : afterSpike.sublist(afterSpike.length - inactivityWindow);
    final inactive = tail.every((sample) {
      final movement = sample.movement;
      return movement == null || movement == MovementState.none;
    });

    if (hasImpact && hasOrientation && inactive) {
      return FallStatus.possible;
    }
    return FallStatus.none;
  }

  bool _looksLikeContinuedActivity(List<SensorSample> afterSpike) {
    final activeCount = afterSpike.where((sample) {
      return sample.movement == MovementState.high ||
          sample.movement == MovementState.normal;
    }).length;
    return activeCount >= 3;
  }
}
