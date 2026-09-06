import 'package:aarogya/domain/contracts/health_repository.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

final class InMemoryHealthRepository implements HealthRepository {
  final List<SensorSample> _samples = [];
  PersonalBaseline? _baseline;

  @override
  Future<void> saveSample(SensorSample sample) async {
    _samples.add(sample);
  }

  @override
  Future<List<SensorSample>> recentSamples({int limit = 120}) async {
    if (_samples.length <= limit) {
      return List.unmodifiable(_samples);
    }
    return List.unmodifiable(_samples.sublist(_samples.length - limit));
  }

  @override
  Future<void> saveBaseline(PersonalBaseline baseline) async {
    _baseline = baseline;
  }

  @override
  Future<PersonalBaseline?> latestBaseline() async => _baseline;

  @override
  Future<void> clearSessionData() async {
    _samples.clear();
    _baseline = null;
  }

  void replaceSession({
    List<SensorSample> samples = const [],
    PersonalBaseline? baseline,
  }) {
    _samples
      ..clear()
      ..addAll(samples);
    _baseline = baseline;
  }
}
