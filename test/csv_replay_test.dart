import 'dart:io';

import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/sensors/data/csv_replay_sensor_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses versioned demo datasets without inventing missing values', () {
    const replay = CsvSensorReplay();
    final csv = File('assets/demo/health_deterioration.csv').readAsStringSync();
    final samples = replay.parse(csv, sourceId: 'health_deterioration.csv');

    expect(samples, isNotEmpty);
    expect(samples.first.isSimulation, isTrue);
    expect(samples.first.sourceKind, SensorSourceKind.simulation);
    expect(samples.last.heartRateBpm, 118);
    expect(samples.last.spo2Percent, 93);
  });
}
