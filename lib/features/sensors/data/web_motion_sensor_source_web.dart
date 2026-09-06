import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math' as math;

import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

final class WebMotionSensorSource implements SensorSource {
  final StreamController<SensorSample> _controller =
      StreamController<SensorSample>.broadcast();
  JSFunction? _listener;
  bool _started = false;

  @override
  String get id => 'browser-motion';

  @override
  bool get isSimulation => false;

  @override
  SensorSourceKind get kind => SensorSourceKind.device;

  bool get isAvailable => true;

  @override
  Stream<SensorSample> watch() => _controller.stream;

  @override
  Future<void> start() async {
    if (_started) {
      return;
    }
    _started = true;
    _listener = ((JSObject event) {
      final accel = event['accelerationIncludingGravity'];
      final rotation = event['rotationRate'];
      if (accel == null) {
        return;
      }
      final accelObj = accel as JSObject;
      final x = _num(accelObj, 'x');
      final y = _num(accelObj, 'y');
      final z = _num(accelObj, 'z');
      if (x == null || y == null || z == null) {
        return;
      }
      final magnitude = math.sqrt(x * x + y * y + z * z);
      double? gyro;
      if (rotation != null) {
        final rotationObj = rotation as JSObject;
        gyro = _absMax([
          _num(rotationObj, 'alpha'),
          _num(rotationObj, 'beta'),
          _num(rotationObj, 'gamma'),
        ]);
      }
      if (_controller.isClosed) {
        return;
      }
      _controller.add(
        SensorSample(
          timestamp: DateTime.now().toUtc(),
          accelMagnitude: magnitude,
          gyroMagnitude: gyro,
          movement: _movement(magnitude),
          isSimulation: false,
          sourceId: id,
          sourceKind: SensorSourceKind.device,
        ),
      );
    }).toJS;
    globalContext.callMethod('addEventListener'.toJS, 'devicemotion'.toJS, _listener);
  }

  @override
  Future<void> stop() async {
    if (_listener != null) {
      globalContext.callMethod(
        'removeEventListener'.toJS,
        'devicemotion'.toJS,
        _listener,
      );
    }
    _started = false;
  }

  double? _num(JSObject object, String name) {
    final value = object.getProperty(name.toJS);
    if (value == null) {
      return null;
    }
    return (value as JSNumber).toDartDouble;
  }

  double? _absMax(List<double?> values) {
    final present = [for (final value in values) if (value != null) value.abs()];
    if (present.isEmpty) {
      return null;
    }
    return present.reduce(math.max);
  }

  MovementState _movement(double magnitude) {
    if (magnitude < 1.2) {
      return MovementState.none;
    }
    if (magnitude < 2.5) {
      return MovementState.low;
    }
    if (magnitude < 8) {
      return MovementState.normal;
    }
    if (magnitude < 18) {
      return MovementState.high;
    }
    return MovementState.irregular;
  }
}
