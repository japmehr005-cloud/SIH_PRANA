import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/sensors/data/sensor_preprocessor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('preprocessor keeps source provenance and eda', () {
    final processed = const SensorPreprocessor().process(
      SensorSample(
        timestamp: DateTime.utc(2026, 9, 6),
        heartRateBpm: 72,
        edaMicrosiemens: 0.4,
        sourceId: 'browser-motion',
        sourceKind: SensorSourceKind.device,
        userId: 'user-a',
        isSimulation: false,
      ),
    );
    expect(processed.sourceKind, SensorSourceKind.device);
    expect(processed.sourceId, 'browser-motion');
    expect(processed.userId, 'user-a');
    expect(processed.edaMicrosiemens, 0.4);
    expect(processed.isSimulation, isFalse);
  });
}
