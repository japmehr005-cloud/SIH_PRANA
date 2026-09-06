import 'dart:async';

import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

final class WebBluetoothHeartRateSource implements SensorSource {
  @override
  String get id => 'web-bluetooth-hr';

  @override
  bool get isSimulation => false;

  @override
  SensorSourceKind get kind => SensorSourceKind.wearable;

  bool get isSupported => false;

  bool connected = false;

  Future<bool> connect() async => false;

  @override
  Stream<SensorSample> watch() => const Stream.empty();

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}
}
