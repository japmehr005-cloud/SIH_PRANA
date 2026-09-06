import 'dart:async';

import 'package:aarogya/domain/contracts/replay_sensor_sink.dart';
import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

/// Demo and test injector. Emits [SensorSample] values through [SensorSource].
/// A BLE wearable would implement [SensorSource] separately and not use this class.
final class SimulatedSensorSource implements SensorSource, ReplaySensorSink {
  SimulatedSensorSource({this.id = 'simulated-wearable'});

  @override
  final String id;

  final StreamController<SensorSample> _controller =
      StreamController<SensorSample>.broadcast();
  bool _started = false;

  @override
  bool get isSimulation => true;

  @override
  SensorSourceKind get kind => SensorSourceKind.simulation;

  @override
  Stream<SensorSample> watch() => _controller.stream;

  @override
  Future<void> start() async {
    _started = true;
  }

  @override
  Future<void> stop() async {
    _started = false;
  }

  @override
  Future<void> emit(SensorSample sample) async {
    if (!_started || _controller.isClosed) {
      return;
    }
    _controller.add(
      sample.copyWith(
        isSimulation: true,
        sourceId: id,
        sourceKind: SensorSourceKind.simulation,
      ),
    );
  }

  @override
  Future<void> emitAll(Iterable<SensorSample> samples) async {
    for (final sample in samples) {
      await emit(sample);
    }
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
