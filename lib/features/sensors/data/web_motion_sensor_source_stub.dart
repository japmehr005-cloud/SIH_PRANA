import 'dart:async';

import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

final class WebMotionSensorSource implements SensorSource {
  @override
  String get id => 'browser-motion';

  @override
  bool get isSimulation => false;

  @override
  SensorSourceKind get kind => SensorSourceKind.device;

  bool get isAvailable => false;

  @override
  Stream<SensorSample> watch() => const Stream.empty();

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}
}
