import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

/// Future BLE wearable adapter. Not implemented for the SIH browser demo.
///
/// A production adapter would connect to a supported wrist wearable, map
/// notifications onto [SensorSample], and emit them through [watch].
/// The ingest path stays the same as demo CSV replay.
/// This class does not open a Bluetooth connection.
abstract interface class WearableSensorSource implements SensorSource {}

final class UnsupportedWearableSensorSource implements WearableSensorSource {
  const UnsupportedWearableSensorSource();

  @override
  String get id => 'wearable-unsupported';

  @override
  bool get isSimulation => false;

  @override
  SensorSourceKind get kind => SensorSourceKind.wearable;

  @override
  Stream<SensorSample> watch() => const Stream.empty();

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}
}
