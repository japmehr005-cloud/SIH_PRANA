import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/features/edge_ai/domain/fall_detection_engine.dart';
import 'package:aarogya/features/edge_ai/domain/fall_window_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sparse windows stay on the sequence detector', () {
    final trained = FallWindowModel(
      featureNames: const [
        'smv_max',
        'smv_mean',
        'smv_std',
        'smv_min',
        'post_peak_mean',
        'gyro_mean',
      ],
      coef: const [1, 0, 0, 0, 0, 0],
      intercept: -100,
      imputerMedian: const [1, 1, 1, 1, 1, 1],
      scalerMean: const [0, 0, 0, 0, 0, 0],
      scalerScale: const [1, 1, 1, 1, 1, 1],
      version: 'fall-window-test',
    );
    final detector = CompositeFallDetector(
      sequence: const FallDetectionEngine(),
      trained: trained,
    );
    final start = DateTime.utc(2026, 9, 6, 14);
    final sparse = [
      for (var i = 0; i < 5; i++)
        SensorSample(
          timestamp: start.add(Duration(milliseconds: 200 * i)),
          accelMagnitude: 1.1,
        ),
    ];
    expect(trained.looksLikeImuWindow(sparse), isFalse);
    expect(detector.detect(sparse), FallStatus.none);
    expect(detector.mode, 'simulated-sequence');
  });

  test('dense IMU windows can use the trained path without faking a hit', () {
    final trained = FallWindowModel(
      featureNames: const [
        'smv_max',
        'smv_mean',
        'smv_std',
        'smv_min',
        'post_peak_mean',
        'gyro_mean',
      ],
      coef: const [0, 0, 0, 0, 0, 0],
      intercept: -10,
      imputerMedian: const [1, 1, 1, 1, 1, 1],
      scalerMean: const [0, 0, 0, 0, 0, 0],
      scalerScale: const [1, 1, 1, 1, 1, 1],
      version: 'fall-window-test',
      threshold: 0.99,
    );
    final detector = CompositeFallDetector(
      sequence: const FallDetectionEngine(),
      trained: trained,
    );
    final start = DateTime.utc(2026, 9, 6, 14);
    final dense = [
      for (var i = 0; i < 20; i++)
        SensorSample(
          timestamp: start.add(Duration(milliseconds: 20 * i)),
          accelMagnitude: 1.05,
        ),
    ];
    expect(trained.looksLikeImuWindow(dense), isTrue);
    expect(detector.detect(dense), FallStatus.none);
    expect(detector.mode, 'trained-window');
  });
}
