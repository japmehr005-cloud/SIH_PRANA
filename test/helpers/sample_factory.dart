import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

SensorSample sample({
  required DateTime at,
  double? hr,
  double? spo2,
  double? temp,
  double? accel,
  double? gyro,
  double? orientation,
  MovementState? movement,
  double? battery,
  double? lat,
  double? lon,
}) {
  return SensorSample(
    timestamp: at,
    heartRateBpm: hr,
    spo2Percent: spo2,
    temperatureC: temp,
    accelMagnitude: accel,
    gyroMagnitude: gyro,
    orientationDelta: orientation,
    movement: movement,
    batteryPercent: battery,
    latitude: lat,
    longitude: lon,
    isSimulation: true,
    sourceId: 'test',
  );
}

List<SensorSample> restingSeries({
  required DateTime start,
  int count = 12,
  double hr = 66,
  double spo2 = 98,
}) {
  return List.generate(count, (index) {
    return sample(
      at: start.add(Duration(seconds: index * 5)),
      hr: hr + (index.isEven ? -2 : 2),
      spo2: spo2,
      temp: 36.6,
      accel: 1.05,
      movement: MovementState.low,
      battery: 80,
      lat: 27.717,
      lon: 85.324,
    );
  });
}
