import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

final class WebBluetoothHeartRateSource implements SensorSource {
  final StreamController<SensorSample> _controller =
      StreamController<SensorSample>.broadcast();

  @override
  String get id => 'web-bluetooth-hr';

  @override
  bool get isSimulation => false;

  @override
  SensorSourceKind get kind => SensorSourceKind.wearable;

  bool connected = false;

  bool get isSupported {
    try {
      final navigator = globalContext['navigator'] as JSObject;
      return navigator.has('bluetooth');
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<SensorSample> watch() => _controller.stream;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  Future<bool> connect() async {
    if (!isSupported) {
      return false;
    }
    try {
      final navigator = globalContext['navigator'] as JSObject;
      final bluetooth = navigator['bluetooth'] as JSObject;
      final device = await _promiseObject(
        bluetooth.callMethod(
          'requestDevice'.toJS,
          {
            'filters': [
              {'services': ['heart_rate']},
            ],
          }.jsify(),
        ),
      );
      final gatt = device['gatt'] as JSObject;
      final server = await _promiseObject(gatt.callMethod('connect'.toJS));
      final service = await _promiseObject(
        server.callMethod('getPrimaryService'.toJS, 'heart_rate'.toJS),
      );
      final characteristic = await _promiseObject(
        service.callMethod(
          'getCharacteristic'.toJS,
          'heart_rate_measurement'.toJS,
        ),
      );
      characteristic.callMethod(
        'addEventListener'.toJS,
        'characteristicvaluechanged'.toJS,
        ((JSObject event) {
          final target = event['target'] as JSObject;
          final value = target['value'] as JSObject;
          final hr = _parseHeartRate(value);
          if (hr == null || _controller.isClosed) {
            return;
          }
          _controller.add(
            SensorSample(
              timestamp: DateTime.now().toUtc(),
              heartRateBpm: hr,
              isSimulation: false,
              sourceId: id,
              sourceKind: SensorSourceKind.wearable,
            ),
          );
        }).toJS,
      );
      await _promiseObject(characteristic.callMethod('startNotifications'.toJS));
      connected = true;
      return true;
    } catch (_) {
      connected = false;
      return false;
    }
  }

  Future<JSObject> _promiseObject(JSAny? value) async {
    final result = await (value as JSPromise).toDart;
    return result as JSObject;
  }

  double? _parseHeartRate(JSObject dataView) {
    try {
      final flags = (dataView.callMethod('getUint8'.toJS, 0.toJS) as JSNumber)
          .toDartInt;
      final sixteen = flags & 0x01 == 1;
      final hr = sixteen
          ? (dataView.callMethod('getUint16'.toJS, 1.toJS, true.toJS)
                    as JSNumber)
                .toDartInt
          : (dataView.callMethod('getUint8'.toJS, 1.toJS) as JSNumber)
                .toDartInt;
      return hr.toDouble();
    } catch (_) {
      return null;
    }
  }
}
