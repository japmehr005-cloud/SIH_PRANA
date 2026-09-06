import 'package:aarogya/domain/contracts/health_repository.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/features/health/data/local/aarogya_database.dart';
import 'package:drift/drift.dart';

final class DriftHealthRepository implements HealthRepository {
  DriftHealthRepository(this._db);

  final AarogyaDatabase _db;

  @override
  Future<void> saveSample(SensorSample sample) {
    return _db
        .into(_db.sensorSamples)
        .insert(
          SensorSamplesCompanion.insert(
            timestamp: sample.timestamp,
            sourceId: sample.sourceId,
            heartRateBpm: Value(sample.heartRateBpm),
            spo2Percent: Value(sample.spo2Percent),
            temperatureC: Value(sample.temperatureC),
            accelMagnitude: Value(sample.accelMagnitude),
            gyroMagnitude: Value(sample.gyroMagnitude),
            orientationDelta: Value(sample.orientationDelta),
            movement: Value(sample.movement?.name),
            batteryPercent: Value(sample.batteryPercent),
            latitude: Value(sample.latitude),
            longitude: Value(sample.longitude),
            isSimulation: Value(sample.isSimulation),
          ),
        );
  }

  @override
  Future<List<SensorSample>> recentSamples({int limit = 120}) async {
    final rows =
        await (_db.select(_db.sensorSamples)
              ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
              ..limit(limit))
            .get();
    return rows.reversed.map(_db.mapSample).toList();
  }

  @override
  Future<void> saveBaseline(PersonalBaseline baseline) {
    return _db
        .into(_db.baselineSnapshots)
        .insert(
          BaselineSnapshotsCompanion.insert(
            version: baseline.version,
            sampleCount: baseline.sampleCount,
            computedAt: baseline.computedAt,
            hrLow: Value(baseline.restingHeartRate?.low),
            hrHigh: Value(baseline.restingHeartRate?.high),
            hrMedian: Value(baseline.restingHeartRate?.median),
            spo2Low: Value(baseline.spo2?.low),
            spo2High: Value(baseline.spo2?.high),
            spo2Median: Value(baseline.spo2?.median),
            tempLow: Value(baseline.temperature?.low),
            tempHigh: Value(baseline.temperature?.high),
            tempMedian: Value(baseline.temperature?.median),
          ),
        );
  }

  @override
  Future<PersonalBaseline?> latestBaseline() async {
    final row =
        await (_db.select(_db.baselineSnapshots)
              ..orderBy([(t) => OrderingTerm.desc(t.computedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _db.mapBaseline(row);
  }

  @override
  Future<void> clearSessionData() async {
    await _db.delete(_db.sensorSamples).go();
    await _db.delete(_db.baselineSnapshots).go();
  }
}
