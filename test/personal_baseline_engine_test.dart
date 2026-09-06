import 'package:aarogya/features/baseline/domain/personal_baseline_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

void main() {
  const engine = PersonalBaselineEngine();
  final now = DateTime.utc(2026, 9, 6);

  test('does not establish a baseline with insufficient history', () {
    final baseline = engine.compute(
      samples: restingSeries(start: now, count: 4),
      computedAt: now,
    );
    expect(baseline, isNotNull);
    expect(baseline!.isEstablished, isFalse);
  });

  test('establishes a resting heart-rate range from enough samples', () {
    final baseline = engine.compute(
      samples: restingSeries(start: now, count: 12, hr: 66, spo2: 98),
      computedAt: now,
    )!;
    expect(baseline.isEstablished, isTrue);
    expect(baseline.restingHeartRate, isNotNull);
    expect(baseline.restingHeartRate!.median, inInclusiveRange(64, 68));
    expect(baseline.spo2, isNotNull);
  });

  test('ignores missing readings instead of inventing zeros', () {
    final samples = restingSeries(start: now, count: 12).map((item) {
      return sample(
        at: item.timestamp,
        hr: item.heartRateBpm,
        spo2: null,
        temp: item.temperatureC,
        accel: item.accelMagnitude,
        movement: item.movement,
        battery: item.batteryPercent,
        lat: item.latitude,
        lon: item.longitude,
      );
    }).toList();
    final baseline = engine.compute(samples: samples, computedAt: now)!;
    expect(baseline.restingHeartRate, isNotNull);
    expect(baseline.spo2, isNull);
  });
}
