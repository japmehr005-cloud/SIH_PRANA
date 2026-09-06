import 'package:aarogya/domain/health/sensor_sample.dart';

abstract interface class ReplaySensorSink {
  Future<void> emit(SensorSample sample);
  Future<void> emitAll(Iterable<SensorSample> samples);
}
