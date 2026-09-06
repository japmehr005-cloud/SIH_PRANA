import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

final class SensorSample {
  const SensorSample({
    required this.timestamp,
    this.heartRateBpm,
    this.spo2Percent,
    this.temperatureC,
    this.accelMagnitude,
    this.edaMicrosiemens,
    this.gyroMagnitude,
    this.orientationDelta,
    this.movement,
    this.batteryPercent,
    this.latitude,
    this.longitude,
    this.isSimulation = false,
    this.sourceId = 'unknown',
    this.sourceKind = SensorSourceKind.simulation,
    this.userId,
  });

  final DateTime timestamp;
  final double? heartRateBpm;
  final double? spo2Percent;
  final double? temperatureC;
  final double? accelMagnitude;
  final double? edaMicrosiemens;
  final double? gyroMagnitude;
  final double? orientationDelta;
  final MovementState? movement;
  final double? batteryPercent;
  final double? latitude;
  final double? longitude;
  final bool isSimulation;
  final String sourceId;
  final SensorSourceKind sourceKind;
  final String? userId;

  bool get hasLocation => latitude != null && longitude != null;

  SensorSample copyWith({
    DateTime? timestamp,
    double? heartRateBpm,
    double? spo2Percent,
    double? temperatureC,
    double? accelMagnitude,
    double? edaMicrosiemens,
    double? gyroMagnitude,
    double? orientationDelta,
    MovementState? movement,
    double? batteryPercent,
    double? latitude,
    double? longitude,
    bool? isSimulation,
    String? sourceId,
    SensorSourceKind? sourceKind,
    String? userId,
  }) {
    return SensorSample(
      timestamp: timestamp ?? this.timestamp,
      heartRateBpm: heartRateBpm ?? this.heartRateBpm,
      spo2Percent: spo2Percent ?? this.spo2Percent,
      temperatureC: temperatureC ?? this.temperatureC,
      accelMagnitude: accelMagnitude ?? this.accelMagnitude,
      edaMicrosiemens: edaMicrosiemens ?? this.edaMicrosiemens,
      gyroMagnitude: gyroMagnitude ?? this.gyroMagnitude,
      orientationDelta: orientationDelta ?? this.orientationDelta,
      movement: movement ?? this.movement,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSimulation: isSimulation ?? this.isSimulation,
      sourceId: sourceId ?? this.sourceId,
      sourceKind: sourceKind ?? this.sourceKind,
      userId: userId ?? this.userId,
    );
  }
}
