import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

abstract interface class HealthRepository {
  Future<void> saveSample(SensorSample sample);
  Future<List<SensorSample>> recentSamples({int limit = 120});
  Future<void> saveBaseline(PersonalBaseline baseline);
  Future<PersonalBaseline?> latestBaseline();
  Future<void> clearSessionData();
}
