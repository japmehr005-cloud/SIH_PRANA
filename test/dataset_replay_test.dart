import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/sensors/data/dataset_replay_sensor_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dataset replay keeps provenance and does not invent SpO2', () {
    const csv = '''
timestamp_ms,hr_bpm,spo2,temp_c,accel_mag,eda,source_id,label,subject
0,83.0007,,30.3251,1.1465,0.0830,dataset:noneeg:Subject1,Relax,1
30000,74.0007,96.0000,30.6250,1.1526,0.0830,dataset:noneeg:Subject1,Relax,1
''';
    final samples = const DatasetWindowReplay().parse(csv);
    expect(samples, hasLength(2));
    expect(samples.first.sourceId, 'dataset:noneeg:Subject1');
    expect(samples.first.isSimulation, isFalse);
    expect(samples.first.sourceKind, SensorSourceKind.dataset);
    expect(samples.first.spo2Percent, isNull);
    expect(samples.last.spo2Percent, 96);
    expect(samples.first.edaMicrosiemens, closeTo(0.083, 0.001));
  });
}
