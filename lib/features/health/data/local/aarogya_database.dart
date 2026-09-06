import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/emergency/disaster_activation_source.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'aarogya_database.g.dart';

@DataClassName('SensorSampleRow')
class SensorSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get heartRateBpm => real().nullable()();
  RealColumn get spo2Percent => real().nullable()();
  RealColumn get temperatureC => real().nullable()();
  RealColumn get accelMagnitude => real().nullable()();
  RealColumn get gyroMagnitude => real().nullable()();
  RealColumn get orientationDelta => real().nullable()();
  TextColumn get movement => text().nullable()();
  RealColumn get batteryPercent => real().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get isSimulation => boolean().withDefault(const Constant(false))();
  TextColumn get sourceId => text()();
}

@DataClassName('BaselineSnapshotRow')
class BaselineSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get version => text()();
  IntColumn get sampleCount => integer()();
  DateTimeColumn get computedAt => dateTime()();
  RealColumn get hrLow => real().nullable()();
  RealColumn get hrHigh => real().nullable()();
  RealColumn get hrMedian => real().nullable()();
  RealColumn get spo2Low => real().nullable()();
  RealColumn get spo2High => real().nullable()();
  RealColumn get spo2Median => real().nullable()();
  RealColumn get tempLow => real().nullable()();
  RealColumn get tempHigh => real().nullable()();
  RealColumn get tempMedian => real().nullable()();
}

@DataClassName('DisasterStateRow')
class DisasterStates extends Table {
  IntColumn get id => integer()();
  TextColumn get phase => text()();
  TextColumn get disasterType => text().nullable()();
  TextColumn get activationSource => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get lastEventId => text().nullable()();
  BoolColumn get stranded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EmergencyEventRow')
class EmergencyEvents extends Table {
  TextColumn get eventId => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get eventType => text()();
  TextColumn get riskLevel => text()();
  TextColumn get fallStatus => text()();
  TextColumn get state => text()();
  TextColumn get connectivity => text()();
  TextColumn get movement => text().nullable()();
  RealColumn get heartRateBpm => real().nullable()();
  RealColumn get spo2Percent => real().nullable()();
  RealColumn get batteryPercent => real().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get originDeviceId => text()();
  IntColumn get hopCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {eventId};
}

@DataClassName('AppPreferenceRow')
class AppPreferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    SensorSamples,
    BaselineSnapshots,
    DisasterStates,
    EmergencyEvents,
    AppPreferences,
  ],
)
class AarogyaDatabase extends _$AarogyaDatabase {
  AarogyaDatabase(super.e);

  factory AarogyaDatabase.disk() {
    return AarogyaDatabase(driftDatabase(name: 'aarogya'));
  }

  factory AarogyaDatabase.memory() {
    return AarogyaDatabase(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 1;

  SensorSample mapSample(SensorSampleRow row) {
    return SensorSample(
      timestamp: row.timestamp,
      heartRateBpm: row.heartRateBpm,
      spo2Percent: row.spo2Percent,
      temperatureC: row.temperatureC,
      accelMagnitude: row.accelMagnitude,
      gyroMagnitude: row.gyroMagnitude,
      orientationDelta: row.orientationDelta,
      movement: MovementStateX.tryParse(row.movement),
      batteryPercent: row.batteryPercent,
      latitude: row.latitude,
      longitude: row.longitude,
      isSimulation: row.isSimulation,
      sourceId: row.sourceId,
    );
  }

  PersonalBaseline mapBaseline(BaselineSnapshotRow row) {
    MetricRange? range(double? low, double? high, double? median) {
      if (low == null || high == null || median == null) {
        return null;
      }
      return MetricRange(low: low, high: high, median: median);
    }

    return PersonalBaseline(
      version: row.version,
      sampleCount: row.sampleCount,
      computedAt: row.computedAt,
      restingHeartRate: range(row.hrLow, row.hrHigh, row.hrMedian),
      spo2: range(row.spo2Low, row.spo2High, row.spo2Median),
      temperature: range(row.tempLow, row.tempHigh, row.tempMedian),
    );
  }

  EmergencySnapshot mapSnapshot(DisasterStateRow row) {
    return EmergencySnapshot(
      phase: EmergencyPhase.values.byName(row.phase),
      disasterType: row.disasterType == null
          ? null
          : DisasterType.values.byName(row.disasterType!),
      activationSource: row.activationSource == null
          ? null
          : DisasterActivationSource.values.byName(row.activationSource!),
      updatedAt: row.updatedAt,
      lastEventId: row.lastEventId,
      stranded: row.stranded,
    );
  }

  EmergencyPacket mapPacket(EmergencyEventRow row) {
    return EmergencyPacket(
      eventId: row.eventId,
      timestamp: row.timestamp,
      eventType: row.eventType,
      riskLevel: RiskLevel.values.byName(row.riskLevel),
      fallStatus: FallStatus.values.byName(row.fallStatus),
      state: PacketState.values.byName(row.state),
      connectivityAtCreation: ConnectivityStatus.values.byName(
        row.connectivity,
      ),
      movement: MovementStateX.tryParse(row.movement),
      heartRateBpm: row.heartRateBpm,
      spo2Percent: row.spo2Percent,
      batteryPercent: row.batteryPercent,
      latitude: row.latitude,
      longitude: row.longitude,
      originDeviceId: row.originDeviceId,
      hopCount: row.hopCount,
      expiresAt: row.expiresAt,
    );
  }
}
