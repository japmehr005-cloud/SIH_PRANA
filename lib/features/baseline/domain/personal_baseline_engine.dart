import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

final class PersonalBaselineEngine {
  const PersonalBaselineEngine();

  static const String version = PersonalBaselinePolicy.version;

  PersonalBaseline? compute({
    required List<SensorSample> samples,
    required DateTime computedAt,
  }) {
    final resting = samples.where((sample) {
      return sample.movement?.isResting ?? false;
    }).toList();

    if (resting.length < PersonalBaselinePolicy.minimumSamples) {
      return PersonalBaseline(
        version: version,
        sampleCount: resting.length,
        computedAt: computedAt,
      );
    }

    return PersonalBaseline(
      version: version,
      sampleCount: resting.length,
      computedAt: computedAt,
      restingHeartRate: _range(resting.map((s) => s.heartRateBpm)),
      spo2: _range(resting.map((s) => s.spo2Percent)),
      temperature: _range(resting.map((s) => s.temperatureC)),
    );
  }

  MetricRange? _range(Iterable<double?> values) {
    final numbers = values.whereType<double>().toList()..sort();
    if (numbers.length < PersonalBaselinePolicy.minimumSamples) {
      return null;
    }
    return MetricRange(
      low: _percentile(numbers, 0.25),
      high: _percentile(numbers, 0.75),
      median: _percentile(numbers, 0.50),
    );
  }

  double _percentile(List<double> sorted, double percentile) {
    if (sorted.length == 1) {
      return sorted.first;
    }
    final index = (sorted.length - 1) * percentile;
    final lower = index.floor();
    final upper = index.ceil();
    if (lower == upper) {
      return sorted[lower];
    }
    final weight = index - lower;
    return sorted[lower] * (1 - weight) + sorted[upper] * weight;
  }
}
