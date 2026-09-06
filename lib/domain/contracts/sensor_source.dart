import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

/// Input contract for physiological samples.
///
/// Demo CSV replay uses a [SensorSourceKind.simulation] adapter.
/// A future BLE wearable should implement the same interface and emit
/// [SensorSample] values into the existing ingest pipeline.
abstract interface class SensorSource {
  String get id;
  bool get isSimulation;
  SensorSourceKind get kind;
  Stream<SensorSample> watch();
  Future<void> start();
  Future<void> stop();
}
