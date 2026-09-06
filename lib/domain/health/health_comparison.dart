import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

/// Compact comparison of current measurements, personal baseline, and window stats.
///
/// Intended for product copy and emergency packets — not a feature dump.
final class HealthComparison {
  const HealthComparison({
    this.currentHeartRate,
    this.usualHeartRate,
    this.currentSpo2,
    this.usualSpo2,
    this.windowHeartRateMean,
    this.windowAccelMean,
    this.recentHeartRates = const [],
    this.rulesScore = 0,
    this.modelContribution = 0,
    this.sensorSourceId,
    this.sensorSourceKind,
  });

  final double? currentHeartRate;
  final double? usualHeartRate;
  final double? currentSpo2;
  final double? usualSpo2;
  final double? windowHeartRateMean;
  final double? windowAccelMean;
  final List<double> recentHeartRates;
  final double rulesScore;
  final double modelContribution;
  final String? sensorSourceId;
  final SensorSourceKind? sensorSourceKind;

  factory HealthComparison.fromWindow({
    required SensorSample current,
    required List<SensorSample> recent,
    PersonalBaseline? baseline,
    double rulesScore = 0,
    double modelContribution = 0,
  }) {
    final window = _windowIncludingCurrent(recent, current);
    final focused = window.length <= 30
        ? window
        : window.sublist(window.length - 30);
    final heartRates = [
      for (final sample in focused)
        if (sample.heartRateBpm != null) sample.heartRateBpm!,
    ];
    final accels = [
      for (final sample in focused)
        if (sample.accelMagnitude != null) sample.accelMagnitude!,
    ];
    return HealthComparison(
      currentHeartRate: current.heartRateBpm,
      usualHeartRate: baseline?.restingHeartRate?.median,
      currentSpo2: current.spo2Percent,
      usualSpo2: baseline?.spo2?.median,
      windowHeartRateMean: _mean(heartRates),
      windowAccelMean: _mean(accels),
      recentHeartRates: heartRates.length <= 8
          ? heartRates
          : heartRates.sublist(heartRates.length - 8),
      rulesScore: rulesScore,
      modelContribution: modelContribution,
      sensorSourceId: current.sourceId,
      sensorSourceKind: current.sourceKind,
    );
  }

  static List<SensorSample> _windowIncludingCurrent(
    List<SensorSample> recent,
    SensorSample current,
  ) {
    if (recent.isEmpty) {
      return [current];
    }
    final last = recent.last;
    if (last.timestamp == current.timestamp &&
        last.sourceId == current.sourceId) {
      return recent;
    }
    return [...recent, current];
  }

  static double? _mean(List<double> values) {
    if (values.isEmpty) {
      return null;
    }
    return values.reduce((a, b) => a + b) / values.length;
  }
}
