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
import 'package:aarogya/domain/identity/user_profile.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

Map<String, Object?> encodeSample(SensorSample sample) {
  return {
    'timestamp': sample.timestamp.toIso8601String(),
    'heartRateBpm': sample.heartRateBpm,
    'spo2Percent': sample.spo2Percent,
    'temperatureC': sample.temperatureC,
    'accelMagnitude': sample.accelMagnitude,
    'edaMicrosiemens': sample.edaMicrosiemens,
    'gyroMagnitude': sample.gyroMagnitude,
    'orientationDelta': sample.orientationDelta,
    'movement': sample.movement?.name,
    'batteryPercent': sample.batteryPercent,
    'latitude': sample.latitude,
    'longitude': sample.longitude,
    'isSimulation': sample.isSimulation,
    'sourceId': sample.sourceId,
    'sourceKind': sample.sourceKind.name,
    'userId': sample.userId,
  };
}

SensorSample decodeSample(Map<String, dynamic> raw) {
  return SensorSample(
    timestamp: DateTime.parse(raw['timestamp']! as String),
    heartRateBpm: (raw['heartRateBpm'] as num?)?.toDouble(),
    spo2Percent: (raw['spo2Percent'] as num?)?.toDouble(),
    temperatureC: (raw['temperatureC'] as num?)?.toDouble(),
    accelMagnitude: (raw['accelMagnitude'] as num?)?.toDouble(),
    edaMicrosiemens: (raw['edaMicrosiemens'] as num?)?.toDouble(),
    gyroMagnitude: (raw['gyroMagnitude'] as num?)?.toDouble(),
    orientationDelta: (raw['orientationDelta'] as num?)?.toDouble(),
    movement: MovementStateX.tryParse(raw['movement'] as String?),
    batteryPercent: (raw['batteryPercent'] as num?)?.toDouble(),
    latitude: (raw['latitude'] as num?)?.toDouble(),
    longitude: (raw['longitude'] as num?)?.toDouble(),
    isSimulation: raw['isSimulation'] as bool? ?? false,
    sourceId: raw['sourceId'] as String? ?? 'unknown',
    sourceKind:
        SensorSourceKindX.tryParse(raw['sourceKind'] as String?) ??
        SensorSourceKind.simulation,
    userId: raw['userId'] as String?,
  );
}

Map<String, Object?> encodeBaseline(PersonalBaseline baseline) {
  Map<String, Object?>? range(MetricRange? value) {
    if (value == null) {
      return null;
    }
    return {'low': value.low, 'high': value.high, 'median': value.median};
  }

  return {
    'version': baseline.version,
    'sampleCount': baseline.sampleCount,
    'computedAt': baseline.computedAt.toIso8601String(),
    'restingHeartRate': range(baseline.restingHeartRate),
    'spo2': range(baseline.spo2),
    'temperature': range(baseline.temperature),
    'userId': baseline.userId,
  };
}

PersonalBaseline decodeBaseline(Map<String, dynamic> raw) {
  MetricRange? range(Object? value) {
    if (value is! Map) {
      return null;
    }
    final mapped = Map<String, Object?>.from(value);
    return MetricRange(
      low: (mapped['low'] as num).toDouble(),
      high: (mapped['high'] as num).toDouble(),
      median: (mapped['median'] as num).toDouble(),
    );
  }

  return PersonalBaseline(
    version: raw['version'] as String,
    sampleCount: (raw['sampleCount'] as num).toInt(),
    computedAt: DateTime.parse(raw['computedAt']! as String),
    restingHeartRate: range(raw['restingHeartRate']),
    spo2: range(raw['spo2']),
    temperature: range(raw['temperature']),
    userId: raw['userId'] as String?,
  );
}

Map<String, Object?> encodeSnapshot(EmergencySnapshot snapshot) {
  return {
    'phase': snapshot.phase.name,
    'updatedAt': snapshot.updatedAt.toIso8601String(),
    'disasterType': snapshot.disasterType?.name,
    'activationSource': snapshot.activationSource?.name,
    'lastEventId': snapshot.lastEventId,
    'stranded': snapshot.stranded,
    'userId': snapshot.userId,
  };
}

EmergencySnapshot decodeSnapshot(Map<String, dynamic> raw) {
  return EmergencySnapshot(
    phase: EmergencyPhase.values.byName(raw['phase']! as String),
    updatedAt: DateTime.parse(raw['updatedAt']! as String),
    disasterType: raw['disasterType'] == null
        ? null
        : DisasterType.values.byName(raw['disasterType']! as String),
    activationSource: raw['activationSource'] == null
        ? null
        : DisasterActivationSource.values.byName(
            raw['activationSource']! as String,
          ),
    lastEventId: raw['lastEventId'] as String?,
    stranded: raw['stranded'] as bool? ?? false,
    userId: raw['userId'] as String?,
  );
}

Map<String, Object?> encodePacket(EmergencyPacket packet) {
  return {
    'eventId': packet.eventId,
    'timestamp': packet.timestamp.toIso8601String(),
    'eventType': packet.eventType,
    'riskLevel': packet.riskLevel.name,
    'fallStatus': packet.fallStatus.name,
    'state': packet.state.name,
    'connectivityAtCreation': packet.connectivityAtCreation.name,
    'movement': packet.movement?.name,
    'heartRateBpm': packet.heartRateBpm,
    'spo2Percent': packet.spo2Percent,
    'batteryPercent': packet.batteryPercent,
    'latitude': packet.latitude,
    'longitude': packet.longitude,
    'originDeviceId': packet.originDeviceId,
    'hopCount': packet.hopCount,
    'expiresAt': packet.expiresAt?.toIso8601String(),
    'modelVersion': packet.modelVersion,
    'riskScore': packet.riskScore,
    'contextLabel': packet.contextLabel,
    'contextConfidence': packet.contextConfidence,
    'baselineHeartRate': packet.baselineHeartRate,
    'baselineSpo2': packet.baselineSpo2,
    'windowHeartRateMean': packet.windowHeartRateMean,
    'rulesScore': packet.rulesScore,
    'modelContribution': packet.modelContribution,
    'sensorSourceId': packet.sensorSourceId,
    'sensorSourceKind': packet.sensorSourceKind,
    'fallDetectionMode': packet.fallDetectionMode,
    'ownerUserId': packet.ownerUserId,
    'originDisplayName': packet.originDisplayName,
    'receivedByUserId': packet.receivedByUserId,
  };
}

EmergencyPacket decodePacket(Map<String, dynamic> raw) {
  return EmergencyPacket(
    eventId: raw['eventId']! as String,
    timestamp: DateTime.parse(raw['timestamp']! as String),
    eventType: raw['eventType']! as String,
    riskLevel: RiskLevel.values.byName(raw['riskLevel']! as String),
    fallStatus: FallStatus.values.byName(raw['fallStatus']! as String),
    state: PacketState.values.byName(raw['state']! as String),
    connectivityAtCreation: ConnectivityStatus.values.byName(
      raw['connectivityAtCreation']! as String,
    ),
    movement: MovementStateX.tryParse(raw['movement'] as String?),
    heartRateBpm: (raw['heartRateBpm'] as num?)?.toDouble(),
    spo2Percent: (raw['spo2Percent'] as num?)?.toDouble(),
    batteryPercent: (raw['batteryPercent'] as num?)?.toDouble(),
    latitude: (raw['latitude'] as num?)?.toDouble(),
    longitude: (raw['longitude'] as num?)?.toDouble(),
    originDeviceId: raw['originDeviceId'] as String? ?? 'local-device',
    hopCount: (raw['hopCount'] as num?)?.toInt() ?? 0,
    expiresAt: raw['expiresAt'] == null
        ? null
        : DateTime.parse(raw['expiresAt']! as String),
    modelVersion: raw['modelVersion'] as String?,
    riskScore: (raw['riskScore'] as num?)?.toDouble(),
    contextLabel: raw['contextLabel'] as String?,
    contextConfidence: (raw['contextConfidence'] as num?)?.toDouble(),
    baselineHeartRate: (raw['baselineHeartRate'] as num?)?.toDouble(),
    baselineSpo2: (raw['baselineSpo2'] as num?)?.toDouble(),
    windowHeartRateMean: (raw['windowHeartRateMean'] as num?)?.toDouble(),
    rulesScore: (raw['rulesScore'] as num?)?.toDouble(),
    modelContribution: (raw['modelContribution'] as num?)?.toDouble(),
    sensorSourceId: raw['sensorSourceId'] as String?,
    sensorSourceKind: raw['sensorSourceKind'] as String?,
    fallDetectionMode:
        raw['fallDetectionMode'] as String? ?? 'simulated-sequence',
    ownerUserId: raw['ownerUserId'] as String? ?? '',
    originDisplayName: raw['originDisplayName'] as String? ?? '',
    receivedByUserId: raw['receivedByUserId'] as String? ?? '',
  );
}

Map<String, Object?> encodeProfile(UserProfile profile) {
  return {
    'userId': profile.userId,
    'displayName': profile.displayName,
    'email': profile.email,
    'locale': profile.locale,
    'consentSync': profile.consentSync,
    'consentEmergencyShare': profile.consentEmergencyShare,
  };
}

UserProfile decodeProfile(Map<String, dynamic> raw) {
  return UserProfile(
    userId: raw['userId']! as String,
    displayName: raw['displayName']! as String,
    email: raw['email'] as String?,
    locale: raw['locale'] as String? ?? 'en',
    consentSync: raw['consentSync'] as bool? ?? true,
    consentEmergencyShare: raw['consentEmergencyShare'] as bool? ?? true,
  );
}

Map<String, Object?> encodeAssessment(RiskAssessment assessment) {
  return {
    'level': assessment.level.name,
    'score': assessment.score,
    'reasons': [for (final reason in assessment.reasons) reason.name],
    'timestamp': assessment.timestamp.toIso8601String(),
    'modelVersion': assessment.modelVersion,
    'insufficientData': assessment.insufficientData,
    'contextLabel': assessment.contextLabel,
    'contextConfidence': assessment.contextConfidence,
    'usedTrainedModel': assessment.usedTrainedModel,
    'rulesScore': assessment.rulesScore,
    'modelContribution': assessment.modelContribution,
    'comparison': assessment.comparison == null
        ? null
        : {
            'currentHeartRate': assessment.comparison!.currentHeartRate,
            'usualHeartRate': assessment.comparison!.usualHeartRate,
            'currentSpo2': assessment.comparison!.currentSpo2,
            'usualSpo2': assessment.comparison!.usualSpo2,
            'windowHeartRateMean': assessment.comparison!.windowHeartRateMean,
            'rulesScore': assessment.comparison!.rulesScore,
            'modelContribution': assessment.comparison!.modelContribution,
            'sensorSourceId': assessment.comparison!.sensorSourceId,
            'sensorSourceKind': assessment.comparison!.sensorSourceKind?.name,
          },
  };
}

RiskAssessment decodeAssessment(Map<String, dynamic> raw) {
  final comparisonRaw = raw['comparison'];
  return RiskAssessment(
    level: RiskLevel.values.byName(raw['level']! as String),
    score: (raw['score'] as num).toDouble(),
    reasons: [
      for (final reason in raw['reasons'] as List<dynamic>? ?? const [])
        RiskReasonCode.values.byName(reason as String),
    ],
    timestamp: DateTime.parse(raw['timestamp']! as String),
    modelVersion: raw['modelVersion'] as String? ?? 'physio-context-v1',
    insufficientData: raw['insufficientData'] as bool? ?? false,
    contextLabel: raw['contextLabel'] as String?,
    contextConfidence: (raw['contextConfidence'] as num?)?.toDouble(),
    usedTrainedModel: raw['usedTrainedModel'] as bool? ?? false,
    rulesScore: (raw['rulesScore'] as num?)?.toDouble() ?? 0,
    modelContribution: (raw['modelContribution'] as num?)?.toDouble() ?? 0,
    comparison: comparisonRaw is Map
        ? HealthComparison(
            currentHeartRate: (comparisonRaw['currentHeartRate'] as num?)
                ?.toDouble(),
            usualHeartRate: (comparisonRaw['usualHeartRate'] as num?)
                ?.toDouble(),
            currentSpo2: (comparisonRaw['currentSpo2'] as num?)?.toDouble(),
            usualSpo2: (comparisonRaw['usualSpo2'] as num?)?.toDouble(),
            windowHeartRateMean: (comparisonRaw['windowHeartRateMean'] as num?)
                ?.toDouble(),
            rulesScore: (comparisonRaw['rulesScore'] as num?)?.toDouble() ?? 0,
            modelContribution:
                (comparisonRaw['modelContribution'] as num?)?.toDouble() ?? 0,
            sensorSourceId: comparisonRaw['sensorSourceId'] as String?,
            sensorSourceKind: SensorSourceKindX.tryParse(
              comparisonRaw['sensorSourceKind'] as String?,
            ),
          )
        : null,
  );
}
