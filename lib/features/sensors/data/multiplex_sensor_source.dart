import 'dart:async';

import 'package:aarogya/domain/contracts/replay_sensor_sink.dart';
import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/sensors/data/simulated_sensor_source.dart';

final class MultiplexSensorSource implements SensorSource, ReplaySensorSink {
  MultiplexSensorSource({
    required this.replay,
    List<SensorSource> live = const [],
  }) : live = List.unmodifiable(live);

  final SimulatedSensorSource replay;
  final List<SensorSource> live;
  final StreamController<SensorSample> _merged =
      StreamController<SensorSample>.broadcast();
  final List<StreamSubscription<SensorSample>> _subs = [];

  @override
  String get id => 'multiplex-sensors';

  @override
  bool get isSimulation => replay.isSimulation && live.every((s) => s.isSimulation);

  @override
  SensorSourceKind get kind {
    for (final source in live) {
      if (!source.isSimulation) {
        return source.kind;
      }
    }
    return SensorSourceKind.simulation;
  }

  @override
  Stream<SensorSample> watch() => _merged.stream;

  @override
  Future<void> start() async {
    await replay.start();
    _subs.add(replay.watch().listen(_merged.add));
    for (final source in live) {
      await source.start();
      _subs.add(source.watch().listen(_merged.add));
    }
  }

  @override
  Future<void> stop() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    _subs.clear();
    await replay.stop();
    for (final source in live) {
      await source.stop();
    }
  }

  @override
  Future<void> emit(SensorSample sample) => replay.emit(sample);

  @override
  Future<void> emitAll(Iterable<SensorSample> samples) => replay.emitAll(samples);

  Future<void> dispose() async {
    await stop();
    await replay.dispose();
    await _merged.close();
  }
}
