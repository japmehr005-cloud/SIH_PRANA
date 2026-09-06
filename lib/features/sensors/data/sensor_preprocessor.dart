import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

final class SensorPreprocessor {
  const SensorPreprocessor();

  static const String version = 'preprocess-v1';

  SensorSample process(SensorSample raw) {
    return SensorSample(
      timestamp: raw.timestamp,
      heartRateBpm: _sanitizeRange(raw.heartRateBpm, min: 30, max: 220),
      spo2Percent: _sanitizeRange(raw.spo2Percent, min: 50, max: 100),
      temperatureC: _sanitizeRange(raw.temperatureC, min: 30, max: 45),
      accelMagnitude: _nonNegative(raw.accelMagnitude),
      gyroMagnitude: _nonNegative(raw.gyroMagnitude),
      orientationDelta: _nonNegative(raw.orientationDelta),
      movement: raw.movement ?? _inferMovement(raw.accelMagnitude),
      batteryPercent: _sanitizeRange(raw.batteryPercent, min: 0, max: 100),
      latitude: raw.latitude,
      longitude: raw.longitude,
      isSimulation: raw.isSimulation,
      sourceId: raw.sourceId,
      sourceKind: raw.sourceKind,
      userId: raw.userId,
      edaMicrosiemens: raw.edaMicrosiemens,
    );
  }

  MovementState? _inferMovement(double? accelMagnitude) {
    if (accelMagnitude == null) {
      return null;
    }
    if (accelMagnitude < 1.2) {
      return MovementState.none;
    }
    if (accelMagnitude < 2.5) {
      return MovementState.low;
    }
    if (accelMagnitude < 8) {
      return MovementState.normal;
    }
    if (accelMagnitude < 18) {
      return MovementState.high;
    }
    return MovementState.irregular;
  }

  double? _sanitizeRange(
    double? value, {
    required double min,
    required double max,
  }) {
    if (value == null) {
      return null;
    }
    if (value < min || value > max) {
      return null;
    }
    return value;
  }

  double? _nonNegative(double? value) {
    if (value == null) {
      return null;
    }
    if (value < 0) {
      return null;
    }
    return value;
  }
}
