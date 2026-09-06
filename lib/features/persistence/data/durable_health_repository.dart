import 'package:aarogya/domain/contracts/health_repository.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/features/health/data/in_memory_health_repository.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';

final class DurableHealthRepository implements HealthRepository {
  DurableHealthRepository({
    required this.inner,
    required this.store,
    this.onChanged,
  });

  final InMemoryHealthRepository inner;
  final LocalRecordStore store;
  final Future<void> Function()? onChanged;

  Future<void> loadScoped() async {
    final samples = [
      for (final sample in await store.observations())
        if (_owns(sample.userId)) sample,
    ];
    final baseline = await store.baseline();
    inner.replaceSession(
      samples: samples,
      baseline: baseline != null && _owns(baseline.userId) ? baseline : null,
    );
  }

  Future<void> replaceSession({
    List<SensorSample> samples = const [],
    PersonalBaseline? baseline,
  }) async {
    inner.replaceSession(samples: samples, baseline: baseline);
    await persist();
  }

  Future<void> persist() async {
    await store.saveObservations(await inner.recentSamples());
    await store.saveBaseline(await inner.latestBaseline());
  }

  @override
  Future<void> saveSample(SensorSample sample) async {
    await inner.saveSample(_stampSample(sample));
    await persist();
    await onChanged?.call();
  }

  @override
  Future<List<SensorSample>> recentSamples({int limit = 120}) {
    return inner.recentSamples(limit: limit);
  }

  @override
  Future<void> saveBaseline(PersonalBaseline baseline) async {
    await inner.saveBaseline(_stampBaseline(baseline));
    await persist();
    await onChanged?.call();
  }

  @override
  Future<PersonalBaseline?> latestBaseline() => inner.latestBaseline();

  @override
  Future<void> clearSessionData() async {
    await inner.clearSessionData();
    await persist();
    await store.saveAssessment(null);
    await onChanged?.call();
  }

  SensorSample _stampSample(SensorSample sample) {
    final owner = _ownerId;
    if (owner == null) {
      return sample;
    }
    return sample.copyWith(userId: owner);
  }

  PersonalBaseline _stampBaseline(PersonalBaseline baseline) {
    final owner = _ownerId;
    if (owner == null) {
      return baseline;
    }
    return PersonalBaseline(
      version: baseline.version,
      sampleCount: baseline.sampleCount,
      computedAt: baseline.computedAt,
      restingHeartRate: baseline.restingHeartRate,
      spo2: baseline.spo2,
      temperature: baseline.temperature,
      userId: owner,
    );
  }

  String? get _ownerId {
    final scope = store.scope;
    if (scope.isEmpty || scope == 'local') {
      return null;
    }
    return scope;
  }

  bool _owns(String? userId) {
    final owner = _ownerId;
    if (owner == null) {
      return true;
    }
    return userId == null || userId.isEmpty || userId == owner;
  }
}
