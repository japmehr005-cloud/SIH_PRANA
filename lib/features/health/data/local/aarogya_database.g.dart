// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aarogya_database.dart';

// ignore_for_file: type=lint
class $SensorSamplesTable extends SensorSamples
    with TableInfo<$SensorSamplesTable, SensorSampleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SensorSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heartRateBpmMeta = const VerificationMeta(
    'heartRateBpm',
  );
  @override
  late final GeneratedColumn<double> heartRateBpm = GeneratedColumn<double>(
    'heart_rate_bpm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2PercentMeta = const VerificationMeta(
    'spo2Percent',
  );
  @override
  late final GeneratedColumn<double> spo2Percent = GeneratedColumn<double>(
    'spo2_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureCMeta = const VerificationMeta(
    'temperatureC',
  );
  @override
  late final GeneratedColumn<double> temperatureC = GeneratedColumn<double>(
    'temperature_c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accelMagnitudeMeta = const VerificationMeta(
    'accelMagnitude',
  );
  @override
  late final GeneratedColumn<double> accelMagnitude = GeneratedColumn<double>(
    'accel_magnitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gyroMagnitudeMeta = const VerificationMeta(
    'gyroMagnitude',
  );
  @override
  late final GeneratedColumn<double> gyroMagnitude = GeneratedColumn<double>(
    'gyro_magnitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orientationDeltaMeta = const VerificationMeta(
    'orientationDelta',
  );
  @override
  late final GeneratedColumn<double> orientationDelta = GeneratedColumn<double>(
    'orientation_delta',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _movementMeta = const VerificationMeta(
    'movement',
  );
  @override
  late final GeneratedColumn<String> movement = GeneratedColumn<String>(
    'movement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batteryPercentMeta = const VerificationMeta(
    'batteryPercent',
  );
  @override
  late final GeneratedColumn<double> batteryPercent = GeneratedColumn<double>(
    'battery_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSimulationMeta = const VerificationMeta(
    'isSimulation',
  );
  @override
  late final GeneratedColumn<bool> isSimulation = GeneratedColumn<bool>(
    'is_simulation',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_simulation" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    heartRateBpm,
    spo2Percent,
    temperatureC,
    accelMagnitude,
    gyroMagnitude,
    orientationDelta,
    movement,
    batteryPercent,
    latitude,
    longitude,
    isSimulation,
    sourceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sensor_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<SensorSampleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('heart_rate_bpm')) {
      context.handle(
        _heartRateBpmMeta,
        heartRateBpm.isAcceptableOrUnknown(
          data['heart_rate_bpm']!,
          _heartRateBpmMeta,
        ),
      );
    }
    if (data.containsKey('spo2_percent')) {
      context.handle(
        _spo2PercentMeta,
        spo2Percent.isAcceptableOrUnknown(
          data['spo2_percent']!,
          _spo2PercentMeta,
        ),
      );
    }
    if (data.containsKey('temperature_c')) {
      context.handle(
        _temperatureCMeta,
        temperatureC.isAcceptableOrUnknown(
          data['temperature_c']!,
          _temperatureCMeta,
        ),
      );
    }
    if (data.containsKey('accel_magnitude')) {
      context.handle(
        _accelMagnitudeMeta,
        accelMagnitude.isAcceptableOrUnknown(
          data['accel_magnitude']!,
          _accelMagnitudeMeta,
        ),
      );
    }
    if (data.containsKey('gyro_magnitude')) {
      context.handle(
        _gyroMagnitudeMeta,
        gyroMagnitude.isAcceptableOrUnknown(
          data['gyro_magnitude']!,
          _gyroMagnitudeMeta,
        ),
      );
    }
    if (data.containsKey('orientation_delta')) {
      context.handle(
        _orientationDeltaMeta,
        orientationDelta.isAcceptableOrUnknown(
          data['orientation_delta']!,
          _orientationDeltaMeta,
        ),
      );
    }
    if (data.containsKey('movement')) {
      context.handle(
        _movementMeta,
        movement.isAcceptableOrUnknown(data['movement']!, _movementMeta),
      );
    }
    if (data.containsKey('battery_percent')) {
      context.handle(
        _batteryPercentMeta,
        batteryPercent.isAcceptableOrUnknown(
          data['battery_percent']!,
          _batteryPercentMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('is_simulation')) {
      context.handle(
        _isSimulationMeta,
        isSimulation.isAcceptableOrUnknown(
          data['is_simulation']!,
          _isSimulationMeta,
        ),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SensorSampleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SensorSampleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      heartRateBpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heart_rate_bpm'],
      ),
      spo2Percent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spo2_percent'],
      ),
      temperatureC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature_c'],
      ),
      accelMagnitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accel_magnitude'],
      ),
      gyroMagnitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gyro_magnitude'],
      ),
      orientationDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}orientation_delta'],
      ),
      movement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement'],
      ),
      batteryPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}battery_percent'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      isSimulation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_simulation'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
    );
  }

  @override
  $SensorSamplesTable createAlias(String alias) {
    return $SensorSamplesTable(attachedDatabase, alias);
  }
}

class SensorSampleRow extends DataClass implements Insertable<SensorSampleRow> {
  final int id;
  final DateTime timestamp;
  final double? heartRateBpm;
  final double? spo2Percent;
  final double? temperatureC;
  final double? accelMagnitude;
  final double? gyroMagnitude;
  final double? orientationDelta;
  final String? movement;
  final double? batteryPercent;
  final double? latitude;
  final double? longitude;
  final bool isSimulation;
  final String sourceId;
  const SensorSampleRow({
    required this.id,
    required this.timestamp,
    this.heartRateBpm,
    this.spo2Percent,
    this.temperatureC,
    this.accelMagnitude,
    this.gyroMagnitude,
    this.orientationDelta,
    this.movement,
    this.batteryPercent,
    this.latitude,
    this.longitude,
    required this.isSimulation,
    required this.sourceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || heartRateBpm != null) {
      map['heart_rate_bpm'] = Variable<double>(heartRateBpm);
    }
    if (!nullToAbsent || spo2Percent != null) {
      map['spo2_percent'] = Variable<double>(spo2Percent);
    }
    if (!nullToAbsent || temperatureC != null) {
      map['temperature_c'] = Variable<double>(temperatureC);
    }
    if (!nullToAbsent || accelMagnitude != null) {
      map['accel_magnitude'] = Variable<double>(accelMagnitude);
    }
    if (!nullToAbsent || gyroMagnitude != null) {
      map['gyro_magnitude'] = Variable<double>(gyroMagnitude);
    }
    if (!nullToAbsent || orientationDelta != null) {
      map['orientation_delta'] = Variable<double>(orientationDelta);
    }
    if (!nullToAbsent || movement != null) {
      map['movement'] = Variable<String>(movement);
    }
    if (!nullToAbsent || batteryPercent != null) {
      map['battery_percent'] = Variable<double>(batteryPercent);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['is_simulation'] = Variable<bool>(isSimulation);
    map['source_id'] = Variable<String>(sourceId);
    return map;
  }

  SensorSamplesCompanion toCompanion(bool nullToAbsent) {
    return SensorSamplesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      heartRateBpm: heartRateBpm == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRateBpm),
      spo2Percent: spo2Percent == null && nullToAbsent
          ? const Value.absent()
          : Value(spo2Percent),
      temperatureC: temperatureC == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureC),
      accelMagnitude: accelMagnitude == null && nullToAbsent
          ? const Value.absent()
          : Value(accelMagnitude),
      gyroMagnitude: gyroMagnitude == null && nullToAbsent
          ? const Value.absent()
          : Value(gyroMagnitude),
      orientationDelta: orientationDelta == null && nullToAbsent
          ? const Value.absent()
          : Value(orientationDelta),
      movement: movement == null && nullToAbsent
          ? const Value.absent()
          : Value(movement),
      batteryPercent: batteryPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(batteryPercent),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      isSimulation: Value(isSimulation),
      sourceId: Value(sourceId),
    );
  }

  factory SensorSampleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SensorSampleRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      heartRateBpm: serializer.fromJson<double?>(json['heartRateBpm']),
      spo2Percent: serializer.fromJson<double?>(json['spo2Percent']),
      temperatureC: serializer.fromJson<double?>(json['temperatureC']),
      accelMagnitude: serializer.fromJson<double?>(json['accelMagnitude']),
      gyroMagnitude: serializer.fromJson<double?>(json['gyroMagnitude']),
      orientationDelta: serializer.fromJson<double?>(json['orientationDelta']),
      movement: serializer.fromJson<String?>(json['movement']),
      batteryPercent: serializer.fromJson<double?>(json['batteryPercent']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      isSimulation: serializer.fromJson<bool>(json['isSimulation']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'heartRateBpm': serializer.toJson<double?>(heartRateBpm),
      'spo2Percent': serializer.toJson<double?>(spo2Percent),
      'temperatureC': serializer.toJson<double?>(temperatureC),
      'accelMagnitude': serializer.toJson<double?>(accelMagnitude),
      'gyroMagnitude': serializer.toJson<double?>(gyroMagnitude),
      'orientationDelta': serializer.toJson<double?>(orientationDelta),
      'movement': serializer.toJson<String?>(movement),
      'batteryPercent': serializer.toJson<double?>(batteryPercent),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'isSimulation': serializer.toJson<bool>(isSimulation),
      'sourceId': serializer.toJson<String>(sourceId),
    };
  }

  SensorSampleRow copyWith({
    int? id,
    DateTime? timestamp,
    Value<double?> heartRateBpm = const Value.absent(),
    Value<double?> spo2Percent = const Value.absent(),
    Value<double?> temperatureC = const Value.absent(),
    Value<double?> accelMagnitude = const Value.absent(),
    Value<double?> gyroMagnitude = const Value.absent(),
    Value<double?> orientationDelta = const Value.absent(),
    Value<String?> movement = const Value.absent(),
    Value<double?> batteryPercent = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    bool? isSimulation,
    String? sourceId,
  }) => SensorSampleRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    heartRateBpm: heartRateBpm.present ? heartRateBpm.value : this.heartRateBpm,
    spo2Percent: spo2Percent.present ? spo2Percent.value : this.spo2Percent,
    temperatureC: temperatureC.present ? temperatureC.value : this.temperatureC,
    accelMagnitude: accelMagnitude.present
        ? accelMagnitude.value
        : this.accelMagnitude,
    gyroMagnitude: gyroMagnitude.present
        ? gyroMagnitude.value
        : this.gyroMagnitude,
    orientationDelta: orientationDelta.present
        ? orientationDelta.value
        : this.orientationDelta,
    movement: movement.present ? movement.value : this.movement,
    batteryPercent: batteryPercent.present
        ? batteryPercent.value
        : this.batteryPercent,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    isSimulation: isSimulation ?? this.isSimulation,
    sourceId: sourceId ?? this.sourceId,
  );
  SensorSampleRow copyWithCompanion(SensorSamplesCompanion data) {
    return SensorSampleRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      heartRateBpm: data.heartRateBpm.present
          ? data.heartRateBpm.value
          : this.heartRateBpm,
      spo2Percent: data.spo2Percent.present
          ? data.spo2Percent.value
          : this.spo2Percent,
      temperatureC: data.temperatureC.present
          ? data.temperatureC.value
          : this.temperatureC,
      accelMagnitude: data.accelMagnitude.present
          ? data.accelMagnitude.value
          : this.accelMagnitude,
      gyroMagnitude: data.gyroMagnitude.present
          ? data.gyroMagnitude.value
          : this.gyroMagnitude,
      orientationDelta: data.orientationDelta.present
          ? data.orientationDelta.value
          : this.orientationDelta,
      movement: data.movement.present ? data.movement.value : this.movement,
      batteryPercent: data.batteryPercent.present
          ? data.batteryPercent.value
          : this.batteryPercent,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isSimulation: data.isSimulation.present
          ? data.isSimulation.value
          : this.isSimulation,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SensorSampleRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('heartRateBpm: $heartRateBpm, ')
          ..write('spo2Percent: $spo2Percent, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('accelMagnitude: $accelMagnitude, ')
          ..write('gyroMagnitude: $gyroMagnitude, ')
          ..write('orientationDelta: $orientationDelta, ')
          ..write('movement: $movement, ')
          ..write('batteryPercent: $batteryPercent, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isSimulation: $isSimulation, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    heartRateBpm,
    spo2Percent,
    temperatureC,
    accelMagnitude,
    gyroMagnitude,
    orientationDelta,
    movement,
    batteryPercent,
    latitude,
    longitude,
    isSimulation,
    sourceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SensorSampleRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.heartRateBpm == this.heartRateBpm &&
          other.spo2Percent == this.spo2Percent &&
          other.temperatureC == this.temperatureC &&
          other.accelMagnitude == this.accelMagnitude &&
          other.gyroMagnitude == this.gyroMagnitude &&
          other.orientationDelta == this.orientationDelta &&
          other.movement == this.movement &&
          other.batteryPercent == this.batteryPercent &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isSimulation == this.isSimulation &&
          other.sourceId == this.sourceId);
}

class SensorSamplesCompanion extends UpdateCompanion<SensorSampleRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double?> heartRateBpm;
  final Value<double?> spo2Percent;
  final Value<double?> temperatureC;
  final Value<double?> accelMagnitude;
  final Value<double?> gyroMagnitude;
  final Value<double?> orientationDelta;
  final Value<String?> movement;
  final Value<double?> batteryPercent;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> isSimulation;
  final Value<String> sourceId;
  const SensorSamplesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.heartRateBpm = const Value.absent(),
    this.spo2Percent = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.accelMagnitude = const Value.absent(),
    this.gyroMagnitude = const Value.absent(),
    this.orientationDelta = const Value.absent(),
    this.movement = const Value.absent(),
    this.batteryPercent = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isSimulation = const Value.absent(),
    this.sourceId = const Value.absent(),
  });
  SensorSamplesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    this.heartRateBpm = const Value.absent(),
    this.spo2Percent = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.accelMagnitude = const Value.absent(),
    this.gyroMagnitude = const Value.absent(),
    this.orientationDelta = const Value.absent(),
    this.movement = const Value.absent(),
    this.batteryPercent = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isSimulation = const Value.absent(),
    required String sourceId,
  }) : timestamp = Value(timestamp),
       sourceId = Value(sourceId);
  static Insertable<SensorSampleRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? heartRateBpm,
    Expression<double>? spo2Percent,
    Expression<double>? temperatureC,
    Expression<double>? accelMagnitude,
    Expression<double>? gyroMagnitude,
    Expression<double>? orientationDelta,
    Expression<String>? movement,
    Expression<double>? batteryPercent,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isSimulation,
    Expression<String>? sourceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (heartRateBpm != null) 'heart_rate_bpm': heartRateBpm,
      if (spo2Percent != null) 'spo2_percent': spo2Percent,
      if (temperatureC != null) 'temperature_c': temperatureC,
      if (accelMagnitude != null) 'accel_magnitude': accelMagnitude,
      if (gyroMagnitude != null) 'gyro_magnitude': gyroMagnitude,
      if (orientationDelta != null) 'orientation_delta': orientationDelta,
      if (movement != null) 'movement': movement,
      if (batteryPercent != null) 'battery_percent': batteryPercent,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isSimulation != null) 'is_simulation': isSimulation,
      if (sourceId != null) 'source_id': sourceId,
    });
  }

  SensorSamplesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<double?>? heartRateBpm,
    Value<double?>? spo2Percent,
    Value<double?>? temperatureC,
    Value<double?>? accelMagnitude,
    Value<double?>? gyroMagnitude,
    Value<double?>? orientationDelta,
    Value<String?>? movement,
    Value<double?>? batteryPercent,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<bool>? isSimulation,
    Value<String>? sourceId,
  }) {
    return SensorSamplesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      heartRateBpm: heartRateBpm ?? this.heartRateBpm,
      spo2Percent: spo2Percent ?? this.spo2Percent,
      temperatureC: temperatureC ?? this.temperatureC,
      accelMagnitude: accelMagnitude ?? this.accelMagnitude,
      gyroMagnitude: gyroMagnitude ?? this.gyroMagnitude,
      orientationDelta: orientationDelta ?? this.orientationDelta,
      movement: movement ?? this.movement,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSimulation: isSimulation ?? this.isSimulation,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (heartRateBpm.present) {
      map['heart_rate_bpm'] = Variable<double>(heartRateBpm.value);
    }
    if (spo2Percent.present) {
      map['spo2_percent'] = Variable<double>(spo2Percent.value);
    }
    if (temperatureC.present) {
      map['temperature_c'] = Variable<double>(temperatureC.value);
    }
    if (accelMagnitude.present) {
      map['accel_magnitude'] = Variable<double>(accelMagnitude.value);
    }
    if (gyroMagnitude.present) {
      map['gyro_magnitude'] = Variable<double>(gyroMagnitude.value);
    }
    if (orientationDelta.present) {
      map['orientation_delta'] = Variable<double>(orientationDelta.value);
    }
    if (movement.present) {
      map['movement'] = Variable<String>(movement.value);
    }
    if (batteryPercent.present) {
      map['battery_percent'] = Variable<double>(batteryPercent.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isSimulation.present) {
      map['is_simulation'] = Variable<bool>(isSimulation.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SensorSamplesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('heartRateBpm: $heartRateBpm, ')
          ..write('spo2Percent: $spo2Percent, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('accelMagnitude: $accelMagnitude, ')
          ..write('gyroMagnitude: $gyroMagnitude, ')
          ..write('orientationDelta: $orientationDelta, ')
          ..write('movement: $movement, ')
          ..write('batteryPercent: $batteryPercent, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isSimulation: $isSimulation, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }
}

class $BaselineSnapshotsTable extends BaselineSnapshots
    with TableInfo<$BaselineSnapshotsTable, BaselineSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BaselineSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleCountMeta = const VerificationMeta(
    'sampleCount',
  );
  @override
  late final GeneratedColumn<int> sampleCount = GeneratedColumn<int>(
    'sample_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _computedAtMeta = const VerificationMeta(
    'computedAt',
  );
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
    'computed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hrLowMeta = const VerificationMeta('hrLow');
  @override
  late final GeneratedColumn<double> hrLow = GeneratedColumn<double>(
    'hr_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrHighMeta = const VerificationMeta('hrHigh');
  @override
  late final GeneratedColumn<double> hrHigh = GeneratedColumn<double>(
    'hr_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrMedianMeta = const VerificationMeta(
    'hrMedian',
  );
  @override
  late final GeneratedColumn<double> hrMedian = GeneratedColumn<double>(
    'hr_median',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2LowMeta = const VerificationMeta(
    'spo2Low',
  );
  @override
  late final GeneratedColumn<double> spo2Low = GeneratedColumn<double>(
    'spo2_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2HighMeta = const VerificationMeta(
    'spo2High',
  );
  @override
  late final GeneratedColumn<double> spo2High = GeneratedColumn<double>(
    'spo2_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2MedianMeta = const VerificationMeta(
    'spo2Median',
  );
  @override
  late final GeneratedColumn<double> spo2Median = GeneratedColumn<double>(
    'spo2_median',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempLowMeta = const VerificationMeta(
    'tempLow',
  );
  @override
  late final GeneratedColumn<double> tempLow = GeneratedColumn<double>(
    'temp_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempHighMeta = const VerificationMeta(
    'tempHigh',
  );
  @override
  late final GeneratedColumn<double> tempHigh = GeneratedColumn<double>(
    'temp_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempMedianMeta = const VerificationMeta(
    'tempMedian',
  );
  @override
  late final GeneratedColumn<double> tempMedian = GeneratedColumn<double>(
    'temp_median',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    sampleCount,
    computedAt,
    hrLow,
    hrHigh,
    hrMedian,
    spo2Low,
    spo2High,
    spo2Median,
    tempLow,
    tempHigh,
    tempMedian,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baseline_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<BaselineSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('sample_count')) {
      context.handle(
        _sampleCountMeta,
        sampleCount.isAcceptableOrUnknown(
          data['sample_count']!,
          _sampleCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sampleCountMeta);
    }
    if (data.containsKey('computed_at')) {
      context.handle(
        _computedAtMeta,
        computedAt.isAcceptableOrUnknown(data['computed_at']!, _computedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    if (data.containsKey('hr_low')) {
      context.handle(
        _hrLowMeta,
        hrLow.isAcceptableOrUnknown(data['hr_low']!, _hrLowMeta),
      );
    }
    if (data.containsKey('hr_high')) {
      context.handle(
        _hrHighMeta,
        hrHigh.isAcceptableOrUnknown(data['hr_high']!, _hrHighMeta),
      );
    }
    if (data.containsKey('hr_median')) {
      context.handle(
        _hrMedianMeta,
        hrMedian.isAcceptableOrUnknown(data['hr_median']!, _hrMedianMeta),
      );
    }
    if (data.containsKey('spo2_low')) {
      context.handle(
        _spo2LowMeta,
        spo2Low.isAcceptableOrUnknown(data['spo2_low']!, _spo2LowMeta),
      );
    }
    if (data.containsKey('spo2_high')) {
      context.handle(
        _spo2HighMeta,
        spo2High.isAcceptableOrUnknown(data['spo2_high']!, _spo2HighMeta),
      );
    }
    if (data.containsKey('spo2_median')) {
      context.handle(
        _spo2MedianMeta,
        spo2Median.isAcceptableOrUnknown(data['spo2_median']!, _spo2MedianMeta),
      );
    }
    if (data.containsKey('temp_low')) {
      context.handle(
        _tempLowMeta,
        tempLow.isAcceptableOrUnknown(data['temp_low']!, _tempLowMeta),
      );
    }
    if (data.containsKey('temp_high')) {
      context.handle(
        _tempHighMeta,
        tempHigh.isAcceptableOrUnknown(data['temp_high']!, _tempHighMeta),
      );
    }
    if (data.containsKey('temp_median')) {
      context.handle(
        _tempMedianMeta,
        tempMedian.isAcceptableOrUnknown(data['temp_median']!, _tempMedianMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BaselineSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaselineSnapshotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      sampleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_count'],
      )!,
      computedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}computed_at'],
      )!,
      hrLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hr_low'],
      ),
      hrHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hr_high'],
      ),
      hrMedian: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hr_median'],
      ),
      spo2Low: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spo2_low'],
      ),
      spo2High: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spo2_high'],
      ),
      spo2Median: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spo2_median'],
      ),
      tempLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp_low'],
      ),
      tempHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp_high'],
      ),
      tempMedian: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp_median'],
      ),
    );
  }

  @override
  $BaselineSnapshotsTable createAlias(String alias) {
    return $BaselineSnapshotsTable(attachedDatabase, alias);
  }
}

class BaselineSnapshotRow extends DataClass
    implements Insertable<BaselineSnapshotRow> {
  final int id;
  final String version;
  final int sampleCount;
  final DateTime computedAt;
  final double? hrLow;
  final double? hrHigh;
  final double? hrMedian;
  final double? spo2Low;
  final double? spo2High;
  final double? spo2Median;
  final double? tempLow;
  final double? tempHigh;
  final double? tempMedian;
  const BaselineSnapshotRow({
    required this.id,
    required this.version,
    required this.sampleCount,
    required this.computedAt,
    this.hrLow,
    this.hrHigh,
    this.hrMedian,
    this.spo2Low,
    this.spo2High,
    this.spo2Median,
    this.tempLow,
    this.tempHigh,
    this.tempMedian,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<String>(version);
    map['sample_count'] = Variable<int>(sampleCount);
    map['computed_at'] = Variable<DateTime>(computedAt);
    if (!nullToAbsent || hrLow != null) {
      map['hr_low'] = Variable<double>(hrLow);
    }
    if (!nullToAbsent || hrHigh != null) {
      map['hr_high'] = Variable<double>(hrHigh);
    }
    if (!nullToAbsent || hrMedian != null) {
      map['hr_median'] = Variable<double>(hrMedian);
    }
    if (!nullToAbsent || spo2Low != null) {
      map['spo2_low'] = Variable<double>(spo2Low);
    }
    if (!nullToAbsent || spo2High != null) {
      map['spo2_high'] = Variable<double>(spo2High);
    }
    if (!nullToAbsent || spo2Median != null) {
      map['spo2_median'] = Variable<double>(spo2Median);
    }
    if (!nullToAbsent || tempLow != null) {
      map['temp_low'] = Variable<double>(tempLow);
    }
    if (!nullToAbsent || tempHigh != null) {
      map['temp_high'] = Variable<double>(tempHigh);
    }
    if (!nullToAbsent || tempMedian != null) {
      map['temp_median'] = Variable<double>(tempMedian);
    }
    return map;
  }

  BaselineSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BaselineSnapshotsCompanion(
      id: Value(id),
      version: Value(version),
      sampleCount: Value(sampleCount),
      computedAt: Value(computedAt),
      hrLow: hrLow == null && nullToAbsent
          ? const Value.absent()
          : Value(hrLow),
      hrHigh: hrHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(hrHigh),
      hrMedian: hrMedian == null && nullToAbsent
          ? const Value.absent()
          : Value(hrMedian),
      spo2Low: spo2Low == null && nullToAbsent
          ? const Value.absent()
          : Value(spo2Low),
      spo2High: spo2High == null && nullToAbsent
          ? const Value.absent()
          : Value(spo2High),
      spo2Median: spo2Median == null && nullToAbsent
          ? const Value.absent()
          : Value(spo2Median),
      tempLow: tempLow == null && nullToAbsent
          ? const Value.absent()
          : Value(tempLow),
      tempHigh: tempHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(tempHigh),
      tempMedian: tempMedian == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMedian),
    );
  }

  factory BaselineSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaselineSnapshotRow(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<String>(json['version']),
      sampleCount: serializer.fromJson<int>(json['sampleCount']),
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
      hrLow: serializer.fromJson<double?>(json['hrLow']),
      hrHigh: serializer.fromJson<double?>(json['hrHigh']),
      hrMedian: serializer.fromJson<double?>(json['hrMedian']),
      spo2Low: serializer.fromJson<double?>(json['spo2Low']),
      spo2High: serializer.fromJson<double?>(json['spo2High']),
      spo2Median: serializer.fromJson<double?>(json['spo2Median']),
      tempLow: serializer.fromJson<double?>(json['tempLow']),
      tempHigh: serializer.fromJson<double?>(json['tempHigh']),
      tempMedian: serializer.fromJson<double?>(json['tempMedian']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<String>(version),
      'sampleCount': serializer.toJson<int>(sampleCount),
      'computedAt': serializer.toJson<DateTime>(computedAt),
      'hrLow': serializer.toJson<double?>(hrLow),
      'hrHigh': serializer.toJson<double?>(hrHigh),
      'hrMedian': serializer.toJson<double?>(hrMedian),
      'spo2Low': serializer.toJson<double?>(spo2Low),
      'spo2High': serializer.toJson<double?>(spo2High),
      'spo2Median': serializer.toJson<double?>(spo2Median),
      'tempLow': serializer.toJson<double?>(tempLow),
      'tempHigh': serializer.toJson<double?>(tempHigh),
      'tempMedian': serializer.toJson<double?>(tempMedian),
    };
  }

  BaselineSnapshotRow copyWith({
    int? id,
    String? version,
    int? sampleCount,
    DateTime? computedAt,
    Value<double?> hrLow = const Value.absent(),
    Value<double?> hrHigh = const Value.absent(),
    Value<double?> hrMedian = const Value.absent(),
    Value<double?> spo2Low = const Value.absent(),
    Value<double?> spo2High = const Value.absent(),
    Value<double?> spo2Median = const Value.absent(),
    Value<double?> tempLow = const Value.absent(),
    Value<double?> tempHigh = const Value.absent(),
    Value<double?> tempMedian = const Value.absent(),
  }) => BaselineSnapshotRow(
    id: id ?? this.id,
    version: version ?? this.version,
    sampleCount: sampleCount ?? this.sampleCount,
    computedAt: computedAt ?? this.computedAt,
    hrLow: hrLow.present ? hrLow.value : this.hrLow,
    hrHigh: hrHigh.present ? hrHigh.value : this.hrHigh,
    hrMedian: hrMedian.present ? hrMedian.value : this.hrMedian,
    spo2Low: spo2Low.present ? spo2Low.value : this.spo2Low,
    spo2High: spo2High.present ? spo2High.value : this.spo2High,
    spo2Median: spo2Median.present ? spo2Median.value : this.spo2Median,
    tempLow: tempLow.present ? tempLow.value : this.tempLow,
    tempHigh: tempHigh.present ? tempHigh.value : this.tempHigh,
    tempMedian: tempMedian.present ? tempMedian.value : this.tempMedian,
  );
  BaselineSnapshotRow copyWithCompanion(BaselineSnapshotsCompanion data) {
    return BaselineSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      sampleCount: data.sampleCount.present
          ? data.sampleCount.value
          : this.sampleCount,
      computedAt: data.computedAt.present
          ? data.computedAt.value
          : this.computedAt,
      hrLow: data.hrLow.present ? data.hrLow.value : this.hrLow,
      hrHigh: data.hrHigh.present ? data.hrHigh.value : this.hrHigh,
      hrMedian: data.hrMedian.present ? data.hrMedian.value : this.hrMedian,
      spo2Low: data.spo2Low.present ? data.spo2Low.value : this.spo2Low,
      spo2High: data.spo2High.present ? data.spo2High.value : this.spo2High,
      spo2Median: data.spo2Median.present
          ? data.spo2Median.value
          : this.spo2Median,
      tempLow: data.tempLow.present ? data.tempLow.value : this.tempLow,
      tempHigh: data.tempHigh.present ? data.tempHigh.value : this.tempHigh,
      tempMedian: data.tempMedian.present
          ? data.tempMedian.value
          : this.tempMedian,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaselineSnapshotRow(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('computedAt: $computedAt, ')
          ..write('hrLow: $hrLow, ')
          ..write('hrHigh: $hrHigh, ')
          ..write('hrMedian: $hrMedian, ')
          ..write('spo2Low: $spo2Low, ')
          ..write('spo2High: $spo2High, ')
          ..write('spo2Median: $spo2Median, ')
          ..write('tempLow: $tempLow, ')
          ..write('tempHigh: $tempHigh, ')
          ..write('tempMedian: $tempMedian')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    version,
    sampleCount,
    computedAt,
    hrLow,
    hrHigh,
    hrMedian,
    spo2Low,
    spo2High,
    spo2Median,
    tempLow,
    tempHigh,
    tempMedian,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaselineSnapshotRow &&
          other.id == this.id &&
          other.version == this.version &&
          other.sampleCount == this.sampleCount &&
          other.computedAt == this.computedAt &&
          other.hrLow == this.hrLow &&
          other.hrHigh == this.hrHigh &&
          other.hrMedian == this.hrMedian &&
          other.spo2Low == this.spo2Low &&
          other.spo2High == this.spo2High &&
          other.spo2Median == this.spo2Median &&
          other.tempLow == this.tempLow &&
          other.tempHigh == this.tempHigh &&
          other.tempMedian == this.tempMedian);
}

class BaselineSnapshotsCompanion extends UpdateCompanion<BaselineSnapshotRow> {
  final Value<int> id;
  final Value<String> version;
  final Value<int> sampleCount;
  final Value<DateTime> computedAt;
  final Value<double?> hrLow;
  final Value<double?> hrHigh;
  final Value<double?> hrMedian;
  final Value<double?> spo2Low;
  final Value<double?> spo2High;
  final Value<double?> spo2Median;
  final Value<double?> tempLow;
  final Value<double?> tempHigh;
  final Value<double?> tempMedian;
  const BaselineSnapshotsCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.computedAt = const Value.absent(),
    this.hrLow = const Value.absent(),
    this.hrHigh = const Value.absent(),
    this.hrMedian = const Value.absent(),
    this.spo2Low = const Value.absent(),
    this.spo2High = const Value.absent(),
    this.spo2Median = const Value.absent(),
    this.tempLow = const Value.absent(),
    this.tempHigh = const Value.absent(),
    this.tempMedian = const Value.absent(),
  });
  BaselineSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String version,
    required int sampleCount,
    required DateTime computedAt,
    this.hrLow = const Value.absent(),
    this.hrHigh = const Value.absent(),
    this.hrMedian = const Value.absent(),
    this.spo2Low = const Value.absent(),
    this.spo2High = const Value.absent(),
    this.spo2Median = const Value.absent(),
    this.tempLow = const Value.absent(),
    this.tempHigh = const Value.absent(),
    this.tempMedian = const Value.absent(),
  }) : version = Value(version),
       sampleCount = Value(sampleCount),
       computedAt = Value(computedAt);
  static Insertable<BaselineSnapshotRow> custom({
    Expression<int>? id,
    Expression<String>? version,
    Expression<int>? sampleCount,
    Expression<DateTime>? computedAt,
    Expression<double>? hrLow,
    Expression<double>? hrHigh,
    Expression<double>? hrMedian,
    Expression<double>? spo2Low,
    Expression<double>? spo2High,
    Expression<double>? spo2Median,
    Expression<double>? tempLow,
    Expression<double>? tempHigh,
    Expression<double>? tempMedian,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (sampleCount != null) 'sample_count': sampleCount,
      if (computedAt != null) 'computed_at': computedAt,
      if (hrLow != null) 'hr_low': hrLow,
      if (hrHigh != null) 'hr_high': hrHigh,
      if (hrMedian != null) 'hr_median': hrMedian,
      if (spo2Low != null) 'spo2_low': spo2Low,
      if (spo2High != null) 'spo2_high': spo2High,
      if (spo2Median != null) 'spo2_median': spo2Median,
      if (tempLow != null) 'temp_low': tempLow,
      if (tempHigh != null) 'temp_high': tempHigh,
      if (tempMedian != null) 'temp_median': tempMedian,
    });
  }

  BaselineSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<String>? version,
    Value<int>? sampleCount,
    Value<DateTime>? computedAt,
    Value<double?>? hrLow,
    Value<double?>? hrHigh,
    Value<double?>? hrMedian,
    Value<double?>? spo2Low,
    Value<double?>? spo2High,
    Value<double?>? spo2Median,
    Value<double?>? tempLow,
    Value<double?>? tempHigh,
    Value<double?>? tempMedian,
  }) {
    return BaselineSnapshotsCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      sampleCount: sampleCount ?? this.sampleCount,
      computedAt: computedAt ?? this.computedAt,
      hrLow: hrLow ?? this.hrLow,
      hrHigh: hrHigh ?? this.hrHigh,
      hrMedian: hrMedian ?? this.hrMedian,
      spo2Low: spo2Low ?? this.spo2Low,
      spo2High: spo2High ?? this.spo2High,
      spo2Median: spo2Median ?? this.spo2Median,
      tempLow: tempLow ?? this.tempLow,
      tempHigh: tempHigh ?? this.tempHigh,
      tempMedian: tempMedian ?? this.tempMedian,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (sampleCount.present) {
      map['sample_count'] = Variable<int>(sampleCount.value);
    }
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
    }
    if (hrLow.present) {
      map['hr_low'] = Variable<double>(hrLow.value);
    }
    if (hrHigh.present) {
      map['hr_high'] = Variable<double>(hrHigh.value);
    }
    if (hrMedian.present) {
      map['hr_median'] = Variable<double>(hrMedian.value);
    }
    if (spo2Low.present) {
      map['spo2_low'] = Variable<double>(spo2Low.value);
    }
    if (spo2High.present) {
      map['spo2_high'] = Variable<double>(spo2High.value);
    }
    if (spo2Median.present) {
      map['spo2_median'] = Variable<double>(spo2Median.value);
    }
    if (tempLow.present) {
      map['temp_low'] = Variable<double>(tempLow.value);
    }
    if (tempHigh.present) {
      map['temp_high'] = Variable<double>(tempHigh.value);
    }
    if (tempMedian.present) {
      map['temp_median'] = Variable<double>(tempMedian.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaselineSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('computedAt: $computedAt, ')
          ..write('hrLow: $hrLow, ')
          ..write('hrHigh: $hrHigh, ')
          ..write('hrMedian: $hrMedian, ')
          ..write('spo2Low: $spo2Low, ')
          ..write('spo2High: $spo2High, ')
          ..write('spo2Median: $spo2Median, ')
          ..write('tempLow: $tempLow, ')
          ..write('tempHigh: $tempHigh, ')
          ..write('tempMedian: $tempMedian')
          ..write(')'))
        .toString();
  }
}

class $DisasterStatesTable extends DisasterStates
    with TableInfo<$DisasterStatesTable, DisasterStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DisasterStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disasterTypeMeta = const VerificationMeta(
    'disasterType',
  );
  @override
  late final GeneratedColumn<String> disasterType = GeneratedColumn<String>(
    'disaster_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activationSourceMeta = const VerificationMeta(
    'activationSource',
  );
  @override
  late final GeneratedColumn<String> activationSource = GeneratedColumn<String>(
    'activation_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastEventIdMeta = const VerificationMeta(
    'lastEventId',
  );
  @override
  late final GeneratedColumn<String> lastEventId = GeneratedColumn<String>(
    'last_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strandedMeta = const VerificationMeta(
    'stranded',
  );
  @override
  late final GeneratedColumn<bool> stranded = GeneratedColumn<bool>(
    'stranded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stranded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phase,
    disasterType,
    activationSource,
    updatedAt,
    lastEventId,
    stranded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'disaster_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<DisasterStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('disaster_type')) {
      context.handle(
        _disasterTypeMeta,
        disasterType.isAcceptableOrUnknown(
          data['disaster_type']!,
          _disasterTypeMeta,
        ),
      );
    }
    if (data.containsKey('activation_source')) {
      context.handle(
        _activationSourceMeta,
        activationSource.isAcceptableOrUnknown(
          data['activation_source']!,
          _activationSourceMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_event_id')) {
      context.handle(
        _lastEventIdMeta,
        lastEventId.isAcceptableOrUnknown(
          data['last_event_id']!,
          _lastEventIdMeta,
        ),
      );
    }
    if (data.containsKey('stranded')) {
      context.handle(
        _strandedMeta,
        stranded.isAcceptableOrUnknown(data['stranded']!, _strandedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DisasterStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DisasterStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      disasterType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disaster_type'],
      ),
      activationSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activation_source'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_event_id'],
      ),
      stranded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stranded'],
      )!,
    );
  }

  @override
  $DisasterStatesTable createAlias(String alias) {
    return $DisasterStatesTable(attachedDatabase, alias);
  }
}

class DisasterStateRow extends DataClass
    implements Insertable<DisasterStateRow> {
  final int id;
  final String phase;
  final String? disasterType;
  final String? activationSource;
  final DateTime updatedAt;
  final String? lastEventId;
  final bool stranded;
  const DisasterStateRow({
    required this.id,
    required this.phase,
    this.disasterType,
    this.activationSource,
    required this.updatedAt,
    this.lastEventId,
    required this.stranded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phase'] = Variable<String>(phase);
    if (!nullToAbsent || disasterType != null) {
      map['disaster_type'] = Variable<String>(disasterType);
    }
    if (!nullToAbsent || activationSource != null) {
      map['activation_source'] = Variable<String>(activationSource);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastEventId != null) {
      map['last_event_id'] = Variable<String>(lastEventId);
    }
    map['stranded'] = Variable<bool>(stranded);
    return map;
  }

  DisasterStatesCompanion toCompanion(bool nullToAbsent) {
    return DisasterStatesCompanion(
      id: Value(id),
      phase: Value(phase),
      disasterType: disasterType == null && nullToAbsent
          ? const Value.absent()
          : Value(disasterType),
      activationSource: activationSource == null && nullToAbsent
          ? const Value.absent()
          : Value(activationSource),
      updatedAt: Value(updatedAt),
      lastEventId: lastEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEventId),
      stranded: Value(stranded),
    );
  }

  factory DisasterStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DisasterStateRow(
      id: serializer.fromJson<int>(json['id']),
      phase: serializer.fromJson<String>(json['phase']),
      disasterType: serializer.fromJson<String?>(json['disasterType']),
      activationSource: serializer.fromJson<String?>(json['activationSource']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastEventId: serializer.fromJson<String?>(json['lastEventId']),
      stranded: serializer.fromJson<bool>(json['stranded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phase': serializer.toJson<String>(phase),
      'disasterType': serializer.toJson<String?>(disasterType),
      'activationSource': serializer.toJson<String?>(activationSource),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastEventId': serializer.toJson<String?>(lastEventId),
      'stranded': serializer.toJson<bool>(stranded),
    };
  }

  DisasterStateRow copyWith({
    int? id,
    String? phase,
    Value<String?> disasterType = const Value.absent(),
    Value<String?> activationSource = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> lastEventId = const Value.absent(),
    bool? stranded,
  }) => DisasterStateRow(
    id: id ?? this.id,
    phase: phase ?? this.phase,
    disasterType: disasterType.present ? disasterType.value : this.disasterType,
    activationSource: activationSource.present
        ? activationSource.value
        : this.activationSource,
    updatedAt: updatedAt ?? this.updatedAt,
    lastEventId: lastEventId.present ? lastEventId.value : this.lastEventId,
    stranded: stranded ?? this.stranded,
  );
  DisasterStateRow copyWithCompanion(DisasterStatesCompanion data) {
    return DisasterStateRow(
      id: data.id.present ? data.id.value : this.id,
      phase: data.phase.present ? data.phase.value : this.phase,
      disasterType: data.disasterType.present
          ? data.disasterType.value
          : this.disasterType,
      activationSource: data.activationSource.present
          ? data.activationSource.value
          : this.activationSource,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastEventId: data.lastEventId.present
          ? data.lastEventId.value
          : this.lastEventId,
      stranded: data.stranded.present ? data.stranded.value : this.stranded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DisasterStateRow(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('disasterType: $disasterType, ')
          ..write('activationSource: $activationSource, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastEventId: $lastEventId, ')
          ..write('stranded: $stranded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phase,
    disasterType,
    activationSource,
    updatedAt,
    lastEventId,
    stranded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DisasterStateRow &&
          other.id == this.id &&
          other.phase == this.phase &&
          other.disasterType == this.disasterType &&
          other.activationSource == this.activationSource &&
          other.updatedAt == this.updatedAt &&
          other.lastEventId == this.lastEventId &&
          other.stranded == this.stranded);
}

class DisasterStatesCompanion extends UpdateCompanion<DisasterStateRow> {
  final Value<int> id;
  final Value<String> phase;
  final Value<String?> disasterType;
  final Value<String?> activationSource;
  final Value<DateTime> updatedAt;
  final Value<String?> lastEventId;
  final Value<bool> stranded;
  const DisasterStatesCompanion({
    this.id = const Value.absent(),
    this.phase = const Value.absent(),
    this.disasterType = const Value.absent(),
    this.activationSource = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastEventId = const Value.absent(),
    this.stranded = const Value.absent(),
  });
  DisasterStatesCompanion.insert({
    this.id = const Value.absent(),
    required String phase,
    this.disasterType = const Value.absent(),
    this.activationSource = const Value.absent(),
    required DateTime updatedAt,
    this.lastEventId = const Value.absent(),
    this.stranded = const Value.absent(),
  }) : phase = Value(phase),
       updatedAt = Value(updatedAt);
  static Insertable<DisasterStateRow> custom({
    Expression<int>? id,
    Expression<String>? phase,
    Expression<String>? disasterType,
    Expression<String>? activationSource,
    Expression<DateTime>? updatedAt,
    Expression<String>? lastEventId,
    Expression<bool>? stranded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phase != null) 'phase': phase,
      if (disasterType != null) 'disaster_type': disasterType,
      if (activationSource != null) 'activation_source': activationSource,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastEventId != null) 'last_event_id': lastEventId,
      if (stranded != null) 'stranded': stranded,
    });
  }

  DisasterStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? phase,
    Value<String?>? disasterType,
    Value<String?>? activationSource,
    Value<DateTime>? updatedAt,
    Value<String?>? lastEventId,
    Value<bool>? stranded,
  }) {
    return DisasterStatesCompanion(
      id: id ?? this.id,
      phase: phase ?? this.phase,
      disasterType: disasterType ?? this.disasterType,
      activationSource: activationSource ?? this.activationSource,
      updatedAt: updatedAt ?? this.updatedAt,
      lastEventId: lastEventId ?? this.lastEventId,
      stranded: stranded ?? this.stranded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (disasterType.present) {
      map['disaster_type'] = Variable<String>(disasterType.value);
    }
    if (activationSource.present) {
      map['activation_source'] = Variable<String>(activationSource.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastEventId.present) {
      map['last_event_id'] = Variable<String>(lastEventId.value);
    }
    if (stranded.present) {
      map['stranded'] = Variable<bool>(stranded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DisasterStatesCompanion(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('disasterType: $disasterType, ')
          ..write('activationSource: $activationSource, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastEventId: $lastEventId, ')
          ..write('stranded: $stranded')
          ..write(')'))
        .toString();
  }
}

class $EmergencyEventsTable extends EmergencyEvents
    with TableInfo<$EmergencyEventsTable, EmergencyEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _riskLevelMeta = const VerificationMeta(
    'riskLevel',
  );
  @override
  late final GeneratedColumn<String> riskLevel = GeneratedColumn<String>(
    'risk_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fallStatusMeta = const VerificationMeta(
    'fallStatus',
  );
  @override
  late final GeneratedColumn<String> fallStatus = GeneratedColumn<String>(
    'fall_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectivityMeta = const VerificationMeta(
    'connectivity',
  );
  @override
  late final GeneratedColumn<String> connectivity = GeneratedColumn<String>(
    'connectivity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movementMeta = const VerificationMeta(
    'movement',
  );
  @override
  late final GeneratedColumn<String> movement = GeneratedColumn<String>(
    'movement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heartRateBpmMeta = const VerificationMeta(
    'heartRateBpm',
  );
  @override
  late final GeneratedColumn<double> heartRateBpm = GeneratedColumn<double>(
    'heart_rate_bpm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2PercentMeta = const VerificationMeta(
    'spo2Percent',
  );
  @override
  late final GeneratedColumn<double> spo2Percent = GeneratedColumn<double>(
    'spo2_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batteryPercentMeta = const VerificationMeta(
    'batteryPercent',
  );
  @override
  late final GeneratedColumn<double> batteryPercent = GeneratedColumn<double>(
    'battery_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hopCountMeta = const VerificationMeta(
    'hopCount',
  );
  @override
  late final GeneratedColumn<int> hopCount = GeneratedColumn<int>(
    'hop_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    timestamp,
    eventType,
    riskLevel,
    fallStatus,
    state,
    connectivity,
    movement,
    heartRateBpm,
    spo2Percent,
    batteryPercent,
    latitude,
    longitude,
    originDeviceId,
    hopCount,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('risk_level')) {
      context.handle(
        _riskLevelMeta,
        riskLevel.isAcceptableOrUnknown(data['risk_level']!, _riskLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_riskLevelMeta);
    }
    if (data.containsKey('fall_status')) {
      context.handle(
        _fallStatusMeta,
        fallStatus.isAcceptableOrUnknown(data['fall_status']!, _fallStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_fallStatusMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('connectivity')) {
      context.handle(
        _connectivityMeta,
        connectivity.isAcceptableOrUnknown(
          data['connectivity']!,
          _connectivityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectivityMeta);
    }
    if (data.containsKey('movement')) {
      context.handle(
        _movementMeta,
        movement.isAcceptableOrUnknown(data['movement']!, _movementMeta),
      );
    }
    if (data.containsKey('heart_rate_bpm')) {
      context.handle(
        _heartRateBpmMeta,
        heartRateBpm.isAcceptableOrUnknown(
          data['heart_rate_bpm']!,
          _heartRateBpmMeta,
        ),
      );
    }
    if (data.containsKey('spo2_percent')) {
      context.handle(
        _spo2PercentMeta,
        spo2Percent.isAcceptableOrUnknown(
          data['spo2_percent']!,
          _spo2PercentMeta,
        ),
      );
    }
    if (data.containsKey('battery_percent')) {
      context.handle(
        _batteryPercentMeta,
        batteryPercent.isAcceptableOrUnknown(
          data['battery_percent']!,
          _batteryPercentMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('hop_count')) {
      context.handle(
        _hopCountMeta,
        hopCount.isAcceptableOrUnknown(data['hop_count']!, _hopCountMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  EmergencyEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyEventRow(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      riskLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}risk_level'],
      )!,
      fallStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fall_status'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      connectivity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connectivity'],
      )!,
      movement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement'],
      ),
      heartRateBpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heart_rate_bpm'],
      ),
      spo2Percent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spo2_percent'],
      ),
      batteryPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}battery_percent'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      hopCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hop_count'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $EmergencyEventsTable createAlias(String alias) {
    return $EmergencyEventsTable(attachedDatabase, alias);
  }
}

class EmergencyEventRow extends DataClass
    implements Insertable<EmergencyEventRow> {
  final String eventId;
  final DateTime timestamp;
  final String eventType;
  final String riskLevel;
  final String fallStatus;
  final String state;
  final String connectivity;
  final String? movement;
  final double? heartRateBpm;
  final double? spo2Percent;
  final double? batteryPercent;
  final double? latitude;
  final double? longitude;
  final String originDeviceId;
  final int hopCount;
  final DateTime? expiresAt;
  const EmergencyEventRow({
    required this.eventId,
    required this.timestamp,
    required this.eventType,
    required this.riskLevel,
    required this.fallStatus,
    required this.state,
    required this.connectivity,
    this.movement,
    this.heartRateBpm,
    this.spo2Percent,
    this.batteryPercent,
    this.latitude,
    this.longitude,
    required this.originDeviceId,
    required this.hopCount,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['event_type'] = Variable<String>(eventType);
    map['risk_level'] = Variable<String>(riskLevel);
    map['fall_status'] = Variable<String>(fallStatus);
    map['state'] = Variable<String>(state);
    map['connectivity'] = Variable<String>(connectivity);
    if (!nullToAbsent || movement != null) {
      map['movement'] = Variable<String>(movement);
    }
    if (!nullToAbsent || heartRateBpm != null) {
      map['heart_rate_bpm'] = Variable<double>(heartRateBpm);
    }
    if (!nullToAbsent || spo2Percent != null) {
      map['spo2_percent'] = Variable<double>(spo2Percent);
    }
    if (!nullToAbsent || batteryPercent != null) {
      map['battery_percent'] = Variable<double>(batteryPercent);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['hop_count'] = Variable<int>(hopCount);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  EmergencyEventsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyEventsCompanion(
      eventId: Value(eventId),
      timestamp: Value(timestamp),
      eventType: Value(eventType),
      riskLevel: Value(riskLevel),
      fallStatus: Value(fallStatus),
      state: Value(state),
      connectivity: Value(connectivity),
      movement: movement == null && nullToAbsent
          ? const Value.absent()
          : Value(movement),
      heartRateBpm: heartRateBpm == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRateBpm),
      spo2Percent: spo2Percent == null && nullToAbsent
          ? const Value.absent()
          : Value(spo2Percent),
      batteryPercent: batteryPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(batteryPercent),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      originDeviceId: Value(originDeviceId),
      hopCount: Value(hopCount),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory EmergencyEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyEventRow(
      eventId: serializer.fromJson<String>(json['eventId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      eventType: serializer.fromJson<String>(json['eventType']),
      riskLevel: serializer.fromJson<String>(json['riskLevel']),
      fallStatus: serializer.fromJson<String>(json['fallStatus']),
      state: serializer.fromJson<String>(json['state']),
      connectivity: serializer.fromJson<String>(json['connectivity']),
      movement: serializer.fromJson<String?>(json['movement']),
      heartRateBpm: serializer.fromJson<double?>(json['heartRateBpm']),
      spo2Percent: serializer.fromJson<double?>(json['spo2Percent']),
      batteryPercent: serializer.fromJson<double?>(json['batteryPercent']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      hopCount: serializer.fromJson<int>(json['hopCount']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'eventType': serializer.toJson<String>(eventType),
      'riskLevel': serializer.toJson<String>(riskLevel),
      'fallStatus': serializer.toJson<String>(fallStatus),
      'state': serializer.toJson<String>(state),
      'connectivity': serializer.toJson<String>(connectivity),
      'movement': serializer.toJson<String?>(movement),
      'heartRateBpm': serializer.toJson<double?>(heartRateBpm),
      'spo2Percent': serializer.toJson<double?>(spo2Percent),
      'batteryPercent': serializer.toJson<double?>(batteryPercent),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'hopCount': serializer.toJson<int>(hopCount),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  EmergencyEventRow copyWith({
    String? eventId,
    DateTime? timestamp,
    String? eventType,
    String? riskLevel,
    String? fallStatus,
    String? state,
    String? connectivity,
    Value<String?> movement = const Value.absent(),
    Value<double?> heartRateBpm = const Value.absent(),
    Value<double?> spo2Percent = const Value.absent(),
    Value<double?> batteryPercent = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    String? originDeviceId,
    int? hopCount,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => EmergencyEventRow(
    eventId: eventId ?? this.eventId,
    timestamp: timestamp ?? this.timestamp,
    eventType: eventType ?? this.eventType,
    riskLevel: riskLevel ?? this.riskLevel,
    fallStatus: fallStatus ?? this.fallStatus,
    state: state ?? this.state,
    connectivity: connectivity ?? this.connectivity,
    movement: movement.present ? movement.value : this.movement,
    heartRateBpm: heartRateBpm.present ? heartRateBpm.value : this.heartRateBpm,
    spo2Percent: spo2Percent.present ? spo2Percent.value : this.spo2Percent,
    batteryPercent: batteryPercent.present
        ? batteryPercent.value
        : this.batteryPercent,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    hopCount: hopCount ?? this.hopCount,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  EmergencyEventRow copyWithCompanion(EmergencyEventsCompanion data) {
    return EmergencyEventRow(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      riskLevel: data.riskLevel.present ? data.riskLevel.value : this.riskLevel,
      fallStatus: data.fallStatus.present
          ? data.fallStatus.value
          : this.fallStatus,
      state: data.state.present ? data.state.value : this.state,
      connectivity: data.connectivity.present
          ? data.connectivity.value
          : this.connectivity,
      movement: data.movement.present ? data.movement.value : this.movement,
      heartRateBpm: data.heartRateBpm.present
          ? data.heartRateBpm.value
          : this.heartRateBpm,
      spo2Percent: data.spo2Percent.present
          ? data.spo2Percent.value
          : this.spo2Percent,
      batteryPercent: data.batteryPercent.present
          ? data.batteryPercent.value
          : this.batteryPercent,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      hopCount: data.hopCount.present ? data.hopCount.value : this.hopCount,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyEventRow(')
          ..write('eventId: $eventId, ')
          ..write('timestamp: $timestamp, ')
          ..write('eventType: $eventType, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('fallStatus: $fallStatus, ')
          ..write('state: $state, ')
          ..write('connectivity: $connectivity, ')
          ..write('movement: $movement, ')
          ..write('heartRateBpm: $heartRateBpm, ')
          ..write('spo2Percent: $spo2Percent, ')
          ..write('batteryPercent: $batteryPercent, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('hopCount: $hopCount, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    timestamp,
    eventType,
    riskLevel,
    fallStatus,
    state,
    connectivity,
    movement,
    heartRateBpm,
    spo2Percent,
    batteryPercent,
    latitude,
    longitude,
    originDeviceId,
    hopCount,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyEventRow &&
          other.eventId == this.eventId &&
          other.timestamp == this.timestamp &&
          other.eventType == this.eventType &&
          other.riskLevel == this.riskLevel &&
          other.fallStatus == this.fallStatus &&
          other.state == this.state &&
          other.connectivity == this.connectivity &&
          other.movement == this.movement &&
          other.heartRateBpm == this.heartRateBpm &&
          other.spo2Percent == this.spo2Percent &&
          other.batteryPercent == this.batteryPercent &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.originDeviceId == this.originDeviceId &&
          other.hopCount == this.hopCount &&
          other.expiresAt == this.expiresAt);
}

class EmergencyEventsCompanion extends UpdateCompanion<EmergencyEventRow> {
  final Value<String> eventId;
  final Value<DateTime> timestamp;
  final Value<String> eventType;
  final Value<String> riskLevel;
  final Value<String> fallStatus;
  final Value<String> state;
  final Value<String> connectivity;
  final Value<String?> movement;
  final Value<double?> heartRateBpm;
  final Value<double?> spo2Percent;
  final Value<double?> batteryPercent;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> originDeviceId;
  final Value<int> hopCount;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const EmergencyEventsCompanion({
    this.eventId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.eventType = const Value.absent(),
    this.riskLevel = const Value.absent(),
    this.fallStatus = const Value.absent(),
    this.state = const Value.absent(),
    this.connectivity = const Value.absent(),
    this.movement = const Value.absent(),
    this.heartRateBpm = const Value.absent(),
    this.spo2Percent = const Value.absent(),
    this.batteryPercent = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.hopCount = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyEventsCompanion.insert({
    required String eventId,
    required DateTime timestamp,
    required String eventType,
    required String riskLevel,
    required String fallStatus,
    required String state,
    required String connectivity,
    this.movement = const Value.absent(),
    this.heartRateBpm = const Value.absent(),
    this.spo2Percent = const Value.absent(),
    this.batteryPercent = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required String originDeviceId,
    this.hopCount = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       timestamp = Value(timestamp),
       eventType = Value(eventType),
       riskLevel = Value(riskLevel),
       fallStatus = Value(fallStatus),
       state = Value(state),
       connectivity = Value(connectivity),
       originDeviceId = Value(originDeviceId);
  static Insertable<EmergencyEventRow> custom({
    Expression<String>? eventId,
    Expression<DateTime>? timestamp,
    Expression<String>? eventType,
    Expression<String>? riskLevel,
    Expression<String>? fallStatus,
    Expression<String>? state,
    Expression<String>? connectivity,
    Expression<String>? movement,
    Expression<double>? heartRateBpm,
    Expression<double>? spo2Percent,
    Expression<double>? batteryPercent,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? originDeviceId,
    Expression<int>? hopCount,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (timestamp != null) 'timestamp': timestamp,
      if (eventType != null) 'event_type': eventType,
      if (riskLevel != null) 'risk_level': riskLevel,
      if (fallStatus != null) 'fall_status': fallStatus,
      if (state != null) 'state': state,
      if (connectivity != null) 'connectivity': connectivity,
      if (movement != null) 'movement': movement,
      if (heartRateBpm != null) 'heart_rate_bpm': heartRateBpm,
      if (spo2Percent != null) 'spo2_percent': spo2Percent,
      if (batteryPercent != null) 'battery_percent': batteryPercent,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (hopCount != null) 'hop_count': hopCount,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyEventsCompanion copyWith({
    Value<String>? eventId,
    Value<DateTime>? timestamp,
    Value<String>? eventType,
    Value<String>? riskLevel,
    Value<String>? fallStatus,
    Value<String>? state,
    Value<String>? connectivity,
    Value<String?>? movement,
    Value<double?>? heartRateBpm,
    Value<double?>? spo2Percent,
    Value<double?>? batteryPercent,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String>? originDeviceId,
    Value<int>? hopCount,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return EmergencyEventsCompanion(
      eventId: eventId ?? this.eventId,
      timestamp: timestamp ?? this.timestamp,
      eventType: eventType ?? this.eventType,
      riskLevel: riskLevel ?? this.riskLevel,
      fallStatus: fallStatus ?? this.fallStatus,
      state: state ?? this.state,
      connectivity: connectivity ?? this.connectivity,
      movement: movement ?? this.movement,
      heartRateBpm: heartRateBpm ?? this.heartRateBpm,
      spo2Percent: spo2Percent ?? this.spo2Percent,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      hopCount: hopCount ?? this.hopCount,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (riskLevel.present) {
      map['risk_level'] = Variable<String>(riskLevel.value);
    }
    if (fallStatus.present) {
      map['fall_status'] = Variable<String>(fallStatus.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (connectivity.present) {
      map['connectivity'] = Variable<String>(connectivity.value);
    }
    if (movement.present) {
      map['movement'] = Variable<String>(movement.value);
    }
    if (heartRateBpm.present) {
      map['heart_rate_bpm'] = Variable<double>(heartRateBpm.value);
    }
    if (spo2Percent.present) {
      map['spo2_percent'] = Variable<double>(spo2Percent.value);
    }
    if (batteryPercent.present) {
      map['battery_percent'] = Variable<double>(batteryPercent.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (hopCount.present) {
      map['hop_count'] = Variable<int>(hopCount.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('timestamp: $timestamp, ')
          ..write('eventType: $eventType, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('fallStatus: $fallStatus, ')
          ..write('state: $state, ')
          ..write('connectivity: $connectivity, ')
          ..write('movement: $movement, ')
          ..write('heartRateBpm: $heartRateBpm, ')
          ..write('spo2Percent: $spo2Percent, ')
          ..write('batteryPercent: $batteryPercent, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('hopCount: $hopCount, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPreferencesTable extends AppPreferences
    with TableInfo<$AppPreferencesTable, AppPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppPreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreferenceRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppPreferencesTable createAlias(String alias) {
    return $AppPreferencesTable(attachedDatabase, alias);
  }
}

class AppPreferenceRow extends DataClass
    implements Insertable<AppPreferenceRow> {
  final String key;
  final String value;
  const AppPreferenceRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppPreferencesCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesCompanion(key: Value(key), value: Value(value));
  }

  factory AppPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreferenceRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppPreferenceRow copyWith({String? key, String? value}) =>
      AppPreferenceRow(key: key ?? this.key, value: value ?? this.value);
  AppPreferenceRow copyWithCompanion(AppPreferencesCompanion data) {
    return AppPreferenceRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferenceRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreferenceRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppPreferencesCompanion extends UpdateCompanion<AppPreferenceRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppPreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPreferencesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppPreferenceRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppPreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AarogyaDatabase extends GeneratedDatabase {
  _$AarogyaDatabase(QueryExecutor e) : super(e);
  $AarogyaDatabaseManager get managers => $AarogyaDatabaseManager(this);
  late final $SensorSamplesTable sensorSamples = $SensorSamplesTable(this);
  late final $BaselineSnapshotsTable baselineSnapshots =
      $BaselineSnapshotsTable(this);
  late final $DisasterStatesTable disasterStates = $DisasterStatesTable(this);
  late final $EmergencyEventsTable emergencyEvents = $EmergencyEventsTable(
    this,
  );
  late final $AppPreferencesTable appPreferences = $AppPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sensorSamples,
    baselineSnapshots,
    disasterStates,
    emergencyEvents,
    appPreferences,
  ];
}

typedef $$SensorSamplesTableCreateCompanionBuilder =
    SensorSamplesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      Value<double?> heartRateBpm,
      Value<double?> spo2Percent,
      Value<double?> temperatureC,
      Value<double?> accelMagnitude,
      Value<double?> gyroMagnitude,
      Value<double?> orientationDelta,
      Value<String?> movement,
      Value<double?> batteryPercent,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> isSimulation,
      required String sourceId,
    });
typedef $$SensorSamplesTableUpdateCompanionBuilder =
    SensorSamplesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<double?> heartRateBpm,
      Value<double?> spo2Percent,
      Value<double?> temperatureC,
      Value<double?> accelMagnitude,
      Value<double?> gyroMagnitude,
      Value<double?> orientationDelta,
      Value<String?> movement,
      Value<double?> batteryPercent,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> isSimulation,
      Value<String> sourceId,
    });

class $$SensorSamplesTableFilterComposer
    extends Composer<_$AarogyaDatabase, $SensorSamplesTable> {
  $$SensorSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heartRateBpm => $composableBuilder(
    column: $table.heartRateBpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accelMagnitude => $composableBuilder(
    column: $table.accelMagnitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gyroMagnitude => $composableBuilder(
    column: $table.gyroMagnitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get orientationDelta => $composableBuilder(
    column: $table.orientationDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get batteryPercent => $composableBuilder(
    column: $table.batteryPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSimulation => $composableBuilder(
    column: $table.isSimulation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SensorSamplesTableOrderingComposer
    extends Composer<_$AarogyaDatabase, $SensorSamplesTable> {
  $$SensorSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heartRateBpm => $composableBuilder(
    column: $table.heartRateBpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accelMagnitude => $composableBuilder(
    column: $table.accelMagnitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gyroMagnitude => $composableBuilder(
    column: $table.gyroMagnitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get orientationDelta => $composableBuilder(
    column: $table.orientationDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get batteryPercent => $composableBuilder(
    column: $table.batteryPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSimulation => $composableBuilder(
    column: $table.isSimulation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SensorSamplesTableAnnotationComposer
    extends Composer<_$AarogyaDatabase, $SensorSamplesTable> {
  $$SensorSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get heartRateBpm => $composableBuilder(
    column: $table.heartRateBpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => column,
  );

  GeneratedColumn<double> get accelMagnitude => $composableBuilder(
    column: $table.accelMagnitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gyroMagnitude => $composableBuilder(
    column: $table.gyroMagnitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get orientationDelta => $composableBuilder(
    column: $table.orientationDelta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get movement =>
      $composableBuilder(column: $table.movement, builder: (column) => column);

  GeneratedColumn<double> get batteryPercent => $composableBuilder(
    column: $table.batteryPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isSimulation => $composableBuilder(
    column: $table.isSimulation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);
}

class $$SensorSamplesTableTableManager
    extends
        RootTableManager<
          _$AarogyaDatabase,
          $SensorSamplesTable,
          SensorSampleRow,
          $$SensorSamplesTableFilterComposer,
          $$SensorSamplesTableOrderingComposer,
          $$SensorSamplesTableAnnotationComposer,
          $$SensorSamplesTableCreateCompanionBuilder,
          $$SensorSamplesTableUpdateCompanionBuilder,
          (
            SensorSampleRow,
            BaseReferences<
              _$AarogyaDatabase,
              $SensorSamplesTable,
              SensorSampleRow
            >,
          ),
          SensorSampleRow,
          PrefetchHooks Function()
        > {
  $$SensorSamplesTableTableManager(
    _$AarogyaDatabase db,
    $SensorSamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SensorSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SensorSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SensorSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double?> heartRateBpm = const Value.absent(),
                Value<double?> spo2Percent = const Value.absent(),
                Value<double?> temperatureC = const Value.absent(),
                Value<double?> accelMagnitude = const Value.absent(),
                Value<double?> gyroMagnitude = const Value.absent(),
                Value<double?> orientationDelta = const Value.absent(),
                Value<String?> movement = const Value.absent(),
                Value<double?> batteryPercent = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> isSimulation = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
              }) => SensorSamplesCompanion(
                id: id,
                timestamp: timestamp,
                heartRateBpm: heartRateBpm,
                spo2Percent: spo2Percent,
                temperatureC: temperatureC,
                accelMagnitude: accelMagnitude,
                gyroMagnitude: gyroMagnitude,
                orientationDelta: orientationDelta,
                movement: movement,
                batteryPercent: batteryPercent,
                latitude: latitude,
                longitude: longitude,
                isSimulation: isSimulation,
                sourceId: sourceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                Value<double?> heartRateBpm = const Value.absent(),
                Value<double?> spo2Percent = const Value.absent(),
                Value<double?> temperatureC = const Value.absent(),
                Value<double?> accelMagnitude = const Value.absent(),
                Value<double?> gyroMagnitude = const Value.absent(),
                Value<double?> orientationDelta = const Value.absent(),
                Value<String?> movement = const Value.absent(),
                Value<double?> batteryPercent = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> isSimulation = const Value.absent(),
                required String sourceId,
              }) => SensorSamplesCompanion.insert(
                id: id,
                timestamp: timestamp,
                heartRateBpm: heartRateBpm,
                spo2Percent: spo2Percent,
                temperatureC: temperatureC,
                accelMagnitude: accelMagnitude,
                gyroMagnitude: gyroMagnitude,
                orientationDelta: orientationDelta,
                movement: movement,
                batteryPercent: batteryPercent,
                latitude: latitude,
                longitude: longitude,
                isSimulation: isSimulation,
                sourceId: sourceId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SensorSamplesTable, SensorSampleRow>(table),
                  BaseReferences<
                    _$AarogyaDatabase,
                    $SensorSamplesTable,
                    SensorSampleRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SensorSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AarogyaDatabase,
      $SensorSamplesTable,
      SensorSampleRow,
      $$SensorSamplesTableFilterComposer,
      $$SensorSamplesTableOrderingComposer,
      $$SensorSamplesTableAnnotationComposer,
      $$SensorSamplesTableCreateCompanionBuilder,
      $$SensorSamplesTableUpdateCompanionBuilder,
      (
        SensorSampleRow,
        BaseReferences<_$AarogyaDatabase, $SensorSamplesTable, SensorSampleRow>,
      ),
      SensorSampleRow,
      PrefetchHooks Function()
    >;
typedef $$BaselineSnapshotsTableCreateCompanionBuilder =
    BaselineSnapshotsCompanion Function({
      Value<int> id,
      required String version,
      required int sampleCount,
      required DateTime computedAt,
      Value<double?> hrLow,
      Value<double?> hrHigh,
      Value<double?> hrMedian,
      Value<double?> spo2Low,
      Value<double?> spo2High,
      Value<double?> spo2Median,
      Value<double?> tempLow,
      Value<double?> tempHigh,
      Value<double?> tempMedian,
    });
typedef $$BaselineSnapshotsTableUpdateCompanionBuilder =
    BaselineSnapshotsCompanion Function({
      Value<int> id,
      Value<String> version,
      Value<int> sampleCount,
      Value<DateTime> computedAt,
      Value<double?> hrLow,
      Value<double?> hrHigh,
      Value<double?> hrMedian,
      Value<double?> spo2Low,
      Value<double?> spo2High,
      Value<double?> spo2Median,
      Value<double?> tempLow,
      Value<double?> tempHigh,
      Value<double?> tempMedian,
    });

class $$BaselineSnapshotsTableFilterComposer
    extends Composer<_$AarogyaDatabase, $BaselineSnapshotsTable> {
  $$BaselineSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrLow => $composableBuilder(
    column: $table.hrLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrHigh => $composableBuilder(
    column: $table.hrHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrMedian => $composableBuilder(
    column: $table.hrMedian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spo2Low => $composableBuilder(
    column: $table.spo2Low,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spo2High => $composableBuilder(
    column: $table.spo2High,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spo2Median => $composableBuilder(
    column: $table.spo2Median,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tempLow => $composableBuilder(
    column: $table.tempLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tempHigh => $composableBuilder(
    column: $table.tempHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tempMedian => $composableBuilder(
    column: $table.tempMedian,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BaselineSnapshotsTableOrderingComposer
    extends Composer<_$AarogyaDatabase, $BaselineSnapshotsTable> {
  $$BaselineSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrLow => $composableBuilder(
    column: $table.hrLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrHigh => $composableBuilder(
    column: $table.hrHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrMedian => $composableBuilder(
    column: $table.hrMedian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spo2Low => $composableBuilder(
    column: $table.spo2Low,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spo2High => $composableBuilder(
    column: $table.spo2High,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spo2Median => $composableBuilder(
    column: $table.spo2Median,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tempLow => $composableBuilder(
    column: $table.tempLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tempHigh => $composableBuilder(
    column: $table.tempHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tempMedian => $composableBuilder(
    column: $table.tempMedian,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BaselineSnapshotsTableAnnotationComposer
    extends Composer<_$AarogyaDatabase, $BaselineSnapshotsTable> {
  $$BaselineSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hrLow =>
      $composableBuilder(column: $table.hrLow, builder: (column) => column);

  GeneratedColumn<double> get hrHigh =>
      $composableBuilder(column: $table.hrHigh, builder: (column) => column);

  GeneratedColumn<double> get hrMedian =>
      $composableBuilder(column: $table.hrMedian, builder: (column) => column);

  GeneratedColumn<double> get spo2Low =>
      $composableBuilder(column: $table.spo2Low, builder: (column) => column);

  GeneratedColumn<double> get spo2High =>
      $composableBuilder(column: $table.spo2High, builder: (column) => column);

  GeneratedColumn<double> get spo2Median => $composableBuilder(
    column: $table.spo2Median,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tempLow =>
      $composableBuilder(column: $table.tempLow, builder: (column) => column);

  GeneratedColumn<double> get tempHigh =>
      $composableBuilder(column: $table.tempHigh, builder: (column) => column);

  GeneratedColumn<double> get tempMedian => $composableBuilder(
    column: $table.tempMedian,
    builder: (column) => column,
  );
}

class $$BaselineSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AarogyaDatabase,
          $BaselineSnapshotsTable,
          BaselineSnapshotRow,
          $$BaselineSnapshotsTableFilterComposer,
          $$BaselineSnapshotsTableOrderingComposer,
          $$BaselineSnapshotsTableAnnotationComposer,
          $$BaselineSnapshotsTableCreateCompanionBuilder,
          $$BaselineSnapshotsTableUpdateCompanionBuilder,
          (
            BaselineSnapshotRow,
            BaseReferences<
              _$AarogyaDatabase,
              $BaselineSnapshotsTable,
              BaselineSnapshotRow
            >,
          ),
          BaselineSnapshotRow,
          PrefetchHooks Function()
        > {
  $$BaselineSnapshotsTableTableManager(
    _$AarogyaDatabase db,
    $BaselineSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BaselineSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BaselineSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BaselineSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<int> sampleCount = const Value.absent(),
                Value<DateTime> computedAt = const Value.absent(),
                Value<double?> hrLow = const Value.absent(),
                Value<double?> hrHigh = const Value.absent(),
                Value<double?> hrMedian = const Value.absent(),
                Value<double?> spo2Low = const Value.absent(),
                Value<double?> spo2High = const Value.absent(),
                Value<double?> spo2Median = const Value.absent(),
                Value<double?> tempLow = const Value.absent(),
                Value<double?> tempHigh = const Value.absent(),
                Value<double?> tempMedian = const Value.absent(),
              }) => BaselineSnapshotsCompanion(
                id: id,
                version: version,
                sampleCount: sampleCount,
                computedAt: computedAt,
                hrLow: hrLow,
                hrHigh: hrHigh,
                hrMedian: hrMedian,
                spo2Low: spo2Low,
                spo2High: spo2High,
                spo2Median: spo2Median,
                tempLow: tempLow,
                tempHigh: tempHigh,
                tempMedian: tempMedian,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String version,
                required int sampleCount,
                required DateTime computedAt,
                Value<double?> hrLow = const Value.absent(),
                Value<double?> hrHigh = const Value.absent(),
                Value<double?> hrMedian = const Value.absent(),
                Value<double?> spo2Low = const Value.absent(),
                Value<double?> spo2High = const Value.absent(),
                Value<double?> spo2Median = const Value.absent(),
                Value<double?> tempLow = const Value.absent(),
                Value<double?> tempHigh = const Value.absent(),
                Value<double?> tempMedian = const Value.absent(),
              }) => BaselineSnapshotsCompanion.insert(
                id: id,
                version: version,
                sampleCount: sampleCount,
                computedAt: computedAt,
                hrLow: hrLow,
                hrHigh: hrHigh,
                hrMedian: hrMedian,
                spo2Low: spo2Low,
                spo2High: spo2High,
                spo2Median: spo2Median,
                tempLow: tempLow,
                tempHigh: tempHigh,
                tempMedian: tempMedian,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BaselineSnapshotsTable, BaselineSnapshotRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AarogyaDatabase,
                    $BaselineSnapshotsTable,
                    BaselineSnapshotRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BaselineSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AarogyaDatabase,
      $BaselineSnapshotsTable,
      BaselineSnapshotRow,
      $$BaselineSnapshotsTableFilterComposer,
      $$BaselineSnapshotsTableOrderingComposer,
      $$BaselineSnapshotsTableAnnotationComposer,
      $$BaselineSnapshotsTableCreateCompanionBuilder,
      $$BaselineSnapshotsTableUpdateCompanionBuilder,
      (
        BaselineSnapshotRow,
        BaseReferences<
          _$AarogyaDatabase,
          $BaselineSnapshotsTable,
          BaselineSnapshotRow
        >,
      ),
      BaselineSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$DisasterStatesTableCreateCompanionBuilder =
    DisasterStatesCompanion Function({
      Value<int> id,
      required String phase,
      Value<String?> disasterType,
      Value<String?> activationSource,
      required DateTime updatedAt,
      Value<String?> lastEventId,
      Value<bool> stranded,
    });
typedef $$DisasterStatesTableUpdateCompanionBuilder =
    DisasterStatesCompanion Function({
      Value<int> id,
      Value<String> phase,
      Value<String?> disasterType,
      Value<String?> activationSource,
      Value<DateTime> updatedAt,
      Value<String?> lastEventId,
      Value<bool> stranded,
    });

class $$DisasterStatesTableFilterComposer
    extends Composer<_$AarogyaDatabase, $DisasterStatesTable> {
  $$DisasterStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get disasterType => $composableBuilder(
    column: $table.disasterType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activationSource => $composableBuilder(
    column: $table.activationSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastEventId => $composableBuilder(
    column: $table.lastEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stranded => $composableBuilder(
    column: $table.stranded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DisasterStatesTableOrderingComposer
    extends Composer<_$AarogyaDatabase, $DisasterStatesTable> {
  $$DisasterStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get disasterType => $composableBuilder(
    column: $table.disasterType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activationSource => $composableBuilder(
    column: $table.activationSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastEventId => $composableBuilder(
    column: $table.lastEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stranded => $composableBuilder(
    column: $table.stranded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DisasterStatesTableAnnotationComposer
    extends Composer<_$AarogyaDatabase, $DisasterStatesTable> {
  $$DisasterStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get disasterType => $composableBuilder(
    column: $table.disasterType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activationSource => $composableBuilder(
    column: $table.activationSource,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastEventId => $composableBuilder(
    column: $table.lastEventId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stranded =>
      $composableBuilder(column: $table.stranded, builder: (column) => column);
}

class $$DisasterStatesTableTableManager
    extends
        RootTableManager<
          _$AarogyaDatabase,
          $DisasterStatesTable,
          DisasterStateRow,
          $$DisasterStatesTableFilterComposer,
          $$DisasterStatesTableOrderingComposer,
          $$DisasterStatesTableAnnotationComposer,
          $$DisasterStatesTableCreateCompanionBuilder,
          $$DisasterStatesTableUpdateCompanionBuilder,
          (
            DisasterStateRow,
            BaseReferences<
              _$AarogyaDatabase,
              $DisasterStatesTable,
              DisasterStateRow
            >,
          ),
          DisasterStateRow,
          PrefetchHooks Function()
        > {
  $$DisasterStatesTableTableManager(
    _$AarogyaDatabase db,
    $DisasterStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DisasterStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DisasterStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DisasterStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String?> disasterType = const Value.absent(),
                Value<String?> activationSource = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> lastEventId = const Value.absent(),
                Value<bool> stranded = const Value.absent(),
              }) => DisasterStatesCompanion(
                id: id,
                phase: phase,
                disasterType: disasterType,
                activationSource: activationSource,
                updatedAt: updatedAt,
                lastEventId: lastEventId,
                stranded: stranded,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String phase,
                Value<String?> disasterType = const Value.absent(),
                Value<String?> activationSource = const Value.absent(),
                required DateTime updatedAt,
                Value<String?> lastEventId = const Value.absent(),
                Value<bool> stranded = const Value.absent(),
              }) => DisasterStatesCompanion.insert(
                id: id,
                phase: phase,
                disasterType: disasterType,
                activationSource: activationSource,
                updatedAt: updatedAt,
                lastEventId: lastEventId,
                stranded: stranded,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DisasterStatesTable, DisasterStateRow>(table),
                  BaseReferences<
                    _$AarogyaDatabase,
                    $DisasterStatesTable,
                    DisasterStateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DisasterStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AarogyaDatabase,
      $DisasterStatesTable,
      DisasterStateRow,
      $$DisasterStatesTableFilterComposer,
      $$DisasterStatesTableOrderingComposer,
      $$DisasterStatesTableAnnotationComposer,
      $$DisasterStatesTableCreateCompanionBuilder,
      $$DisasterStatesTableUpdateCompanionBuilder,
      (
        DisasterStateRow,
        BaseReferences<
          _$AarogyaDatabase,
          $DisasterStatesTable,
          DisasterStateRow
        >,
      ),
      DisasterStateRow,
      PrefetchHooks Function()
    >;
typedef $$EmergencyEventsTableCreateCompanionBuilder =
    EmergencyEventsCompanion Function({
      required String eventId,
      required DateTime timestamp,
      required String eventType,
      required String riskLevel,
      required String fallStatus,
      required String state,
      required String connectivity,
      Value<String?> movement,
      Value<double?> heartRateBpm,
      Value<double?> spo2Percent,
      Value<double?> batteryPercent,
      Value<double?> latitude,
      Value<double?> longitude,
      required String originDeviceId,
      Value<int> hopCount,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$EmergencyEventsTableUpdateCompanionBuilder =
    EmergencyEventsCompanion Function({
      Value<String> eventId,
      Value<DateTime> timestamp,
      Value<String> eventType,
      Value<String> riskLevel,
      Value<String> fallStatus,
      Value<String> state,
      Value<String> connectivity,
      Value<String?> movement,
      Value<double?> heartRateBpm,
      Value<double?> spo2Percent,
      Value<double?> batteryPercent,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String> originDeviceId,
      Value<int> hopCount,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

class $$EmergencyEventsTableFilterComposer
    extends Composer<_$AarogyaDatabase, $EmergencyEventsTable> {
  $$EmergencyEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get riskLevel => $composableBuilder(
    column: $table.riskLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fallStatus => $composableBuilder(
    column: $table.fallStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectivity => $composableBuilder(
    column: $table.connectivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heartRateBpm => $composableBuilder(
    column: $table.heartRateBpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get batteryPercent => $composableBuilder(
    column: $table.batteryPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hopCount => $composableBuilder(
    column: $table.hopCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyEventsTableOrderingComposer
    extends Composer<_$AarogyaDatabase, $EmergencyEventsTable> {
  $$EmergencyEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get riskLevel => $composableBuilder(
    column: $table.riskLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fallStatus => $composableBuilder(
    column: $table.fallStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectivity => $composableBuilder(
    column: $table.connectivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heartRateBpm => $composableBuilder(
    column: $table.heartRateBpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get batteryPercent => $composableBuilder(
    column: $table.batteryPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hopCount => $composableBuilder(
    column: $table.hopCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyEventsTableAnnotationComposer
    extends Composer<_$AarogyaDatabase, $EmergencyEventsTable> {
  $$EmergencyEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get riskLevel =>
      $composableBuilder(column: $table.riskLevel, builder: (column) => column);

  GeneratedColumn<String> get fallStatus => $composableBuilder(
    column: $table.fallStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get connectivity => $composableBuilder(
    column: $table.connectivity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get movement =>
      $composableBuilder(column: $table.movement, builder: (column) => column);

  GeneratedColumn<double> get heartRateBpm => $composableBuilder(
    column: $table.heartRateBpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get batteryPercent => $composableBuilder(
    column: $table.batteryPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hopCount =>
      $composableBuilder(column: $table.hopCount, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$EmergencyEventsTableTableManager
    extends
        RootTableManager<
          _$AarogyaDatabase,
          $EmergencyEventsTable,
          EmergencyEventRow,
          $$EmergencyEventsTableFilterComposer,
          $$EmergencyEventsTableOrderingComposer,
          $$EmergencyEventsTableAnnotationComposer,
          $$EmergencyEventsTableCreateCompanionBuilder,
          $$EmergencyEventsTableUpdateCompanionBuilder,
          (
            EmergencyEventRow,
            BaseReferences<
              _$AarogyaDatabase,
              $EmergencyEventsTable,
              EmergencyEventRow
            >,
          ),
          EmergencyEventRow,
          PrefetchHooks Function()
        > {
  $$EmergencyEventsTableTableManager(
    _$AarogyaDatabase db,
    $EmergencyEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> riskLevel = const Value.absent(),
                Value<String> fallStatus = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> connectivity = const Value.absent(),
                Value<String?> movement = const Value.absent(),
                Value<double?> heartRateBpm = const Value.absent(),
                Value<double?> spo2Percent = const Value.absent(),
                Value<double?> batteryPercent = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<int> hopCount = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyEventsCompanion(
                eventId: eventId,
                timestamp: timestamp,
                eventType: eventType,
                riskLevel: riskLevel,
                fallStatus: fallStatus,
                state: state,
                connectivity: connectivity,
                movement: movement,
                heartRateBpm: heartRateBpm,
                spo2Percent: spo2Percent,
                batteryPercent: batteryPercent,
                latitude: latitude,
                longitude: longitude,
                originDeviceId: originDeviceId,
                hopCount: hopCount,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required DateTime timestamp,
                required String eventType,
                required String riskLevel,
                required String fallStatus,
                required String state,
                required String connectivity,
                Value<String?> movement = const Value.absent(),
                Value<double?> heartRateBpm = const Value.absent(),
                Value<double?> spo2Percent = const Value.absent(),
                Value<double?> batteryPercent = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                required String originDeviceId,
                Value<int> hopCount = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyEventsCompanion.insert(
                eventId: eventId,
                timestamp: timestamp,
                eventType: eventType,
                riskLevel: riskLevel,
                fallStatus: fallStatus,
                state: state,
                connectivity: connectivity,
                movement: movement,
                heartRateBpm: heartRateBpm,
                spo2Percent: spo2Percent,
                batteryPercent: batteryPercent,
                latitude: latitude,
                longitude: longitude,
                originDeviceId: originDeviceId,
                hopCount: hopCount,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmergencyEventsTable, EmergencyEventRow>(table),
                  BaseReferences<
                    _$AarogyaDatabase,
                    $EmergencyEventsTable,
                    EmergencyEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmergencyEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AarogyaDatabase,
      $EmergencyEventsTable,
      EmergencyEventRow,
      $$EmergencyEventsTableFilterComposer,
      $$EmergencyEventsTableOrderingComposer,
      $$EmergencyEventsTableAnnotationComposer,
      $$EmergencyEventsTableCreateCompanionBuilder,
      $$EmergencyEventsTableUpdateCompanionBuilder,
      (
        EmergencyEventRow,
        BaseReferences<
          _$AarogyaDatabase,
          $EmergencyEventsTable,
          EmergencyEventRow
        >,
      ),
      EmergencyEventRow,
      PrefetchHooks Function()
    >;
typedef $$AppPreferencesTableCreateCompanionBuilder =
    AppPreferencesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppPreferencesTableUpdateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppPreferencesTableFilterComposer
    extends Composer<_$AarogyaDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPreferencesTableOrderingComposer
    extends Composer<_$AarogyaDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPreferencesTableAnnotationComposer
    extends Composer<_$AarogyaDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppPreferencesTableTableManager
    extends
        RootTableManager<
          _$AarogyaDatabase,
          $AppPreferencesTable,
          AppPreferenceRow,
          $$AppPreferencesTableFilterComposer,
          $$AppPreferencesTableOrderingComposer,
          $$AppPreferencesTableAnnotationComposer,
          $$AppPreferencesTableCreateCompanionBuilder,
          $$AppPreferencesTableUpdateCompanionBuilder,
          (
            AppPreferenceRow,
            BaseReferences<
              _$AarogyaDatabase,
              $AppPreferencesTable,
              AppPreferenceRow
            >,
          ),
          AppPreferenceRow,
          PrefetchHooks Function()
        > {
  $$AppPreferencesTableTableManager(
    _$AarogyaDatabase db,
    $AppPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppPreferencesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppPreferencesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppPreferencesTable, AppPreferenceRow>(table),
                  BaseReferences<
                    _$AarogyaDatabase,
                    $AppPreferencesTable,
                    AppPreferenceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AarogyaDatabase,
      $AppPreferencesTable,
      AppPreferenceRow,
      $$AppPreferencesTableFilterComposer,
      $$AppPreferencesTableOrderingComposer,
      $$AppPreferencesTableAnnotationComposer,
      $$AppPreferencesTableCreateCompanionBuilder,
      $$AppPreferencesTableUpdateCompanionBuilder,
      (
        AppPreferenceRow,
        BaseReferences<
          _$AarogyaDatabase,
          $AppPreferencesTable,
          AppPreferenceRow
        >,
      ),
      AppPreferenceRow,
      PrefetchHooks Function()
    >;

class $AarogyaDatabaseManager {
  final _$AarogyaDatabase _db;
  $AarogyaDatabaseManager(this._db);
  $$SensorSamplesTableTableManager get sensorSamples =>
      $$SensorSamplesTableTableManager(_db, _db.sensorSamples);
  $$BaselineSnapshotsTableTableManager get baselineSnapshots =>
      $$BaselineSnapshotsTableTableManager(_db, _db.baselineSnapshots);
  $$DisasterStatesTableTableManager get disasterStates =>
      $$DisasterStatesTableTableManager(_db, _db.disasterStates);
  $$EmergencyEventsTableTableManager get emergencyEvents =>
      $$EmergencyEventsTableTableManager(_db, _db.emergencyEvents);
  $$AppPreferencesTableTableManager get appPreferences =>
      $$AppPreferencesTableTableManager(_db, _db.appPreferences);
}
