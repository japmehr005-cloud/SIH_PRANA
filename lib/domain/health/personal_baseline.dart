final class MetricRange {
  const MetricRange({
    required this.low,
    required this.high,
    required this.median,
  });

  final double low;
  final double high;
  final double median;

  bool contains(double value) => value >= low && value <= high;
}

final class PersonalBaseline {
  const PersonalBaseline({
    required this.version,
    required this.sampleCount,
    required this.computedAt,
    this.restingHeartRate,
    this.spo2,
    this.temperature,
    this.userId,
  });

  final String version;
  final int sampleCount;
  final DateTime computedAt;
  final MetricRange? restingHeartRate;
  final MetricRange? spo2;
  final MetricRange? temperature;
  final String? userId;

  bool get isEstablished =>
      sampleCount >= PersonalBaselinePolicy.minimumSamples;
}

abstract final class PersonalBaselinePolicy {
  static const String version = 'baseline-v1';
  static const int minimumSamples = 12;
}
