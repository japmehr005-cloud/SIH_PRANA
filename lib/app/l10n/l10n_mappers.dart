import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/features/disaster/domain/disaster_guidance.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/emergency/disaster_activation_source.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/l10n/app_localizations.dart';

String modeChipLabel(AppLocalizations l10n, EmergencyPhase phase) {
  return switch (phase) {
    EmergencyPhase.normal => l10n.modeChipNormal,
    EmergencyPhase.disasterAlert => l10n.modeChipDisasterAlert,
    EmergencyPhase.disasterActive => l10n.modeChipDisasterActive,
    EmergencyPhase.survival => l10n.modeChipSurvival,
    EmergencyPhase.emergencyEvent => l10n.modeChipEmergency,
    EmergencyPhase.resolved => l10n.modeChipResolved,
  };
}

String phaseLabel(AppLocalizations l10n, EmergencyPhase phase) {
  return switch (phase) {
    EmergencyPhase.normal => l10n.phaseNormal,
    EmergencyPhase.disasterAlert => l10n.phaseDisasterAlert,
    EmergencyPhase.disasterActive => l10n.phaseDisasterActive,
    EmergencyPhase.survival => l10n.phaseSurvival,
    EmergencyPhase.emergencyEvent => l10n.phaseEmergencyEvent,
    EmergencyPhase.resolved => l10n.phaseResolved,
  };
}

String riskLabel(AppLocalizations l10n, RiskLevel level) {
  return switch (level) {
    RiskLevel.low => l10n.riskLow,
    RiskLevel.moderate => l10n.riskModerate,
    RiskLevel.high => l10n.riskHigh,
    RiskLevel.critical => l10n.riskCritical,
  };
}

String connectivityLabel(AppLocalizations l10n, ConnectivityStatus status) {
  return switch (status) {
    ConnectivityStatus.online => l10n.connectivityOnline,
    ConnectivityStatus.offline => l10n.connectivityOffline,
    ConnectivityStatus.limited => l10n.connectivityLimited,
    ConnectivityStatus.unknown => l10n.connectivityUnknown,
  };
}

String movementLabel(AppLocalizations l10n, MovementState? movement) {
  return switch (movement) {
    MovementState.none => l10n.movementNone,
    MovementState.low => l10n.movementLow,
    MovementState.normal => l10n.movementNormal,
    MovementState.high => l10n.movementHigh,
    MovementState.irregular => l10n.movementIrregular,
    null => l10n.unavailable,
  };
}

String fallLabel(AppLocalizations l10n, FallStatus status) {
  return switch (status) {
    FallStatus.none => l10n.fallStatusNone,
    FallStatus.possible => l10n.possibleFallDetected,
    FallStatus.awaitingConfirmation => l10n.awaitingFallConfirmation,
    FallStatus.criticalUnconfirmed => l10n.criticalEvent,
  };
}

String packetLabel(AppLocalizations l10n, PacketState state) {
  return switch (state) {
    PacketState.created || PacketState.stored => l10n.emergencyStoredLocally,
    PacketState.queued => l10n.emergencyQueued,
    PacketState.transmitting => l10n.emergencyTransmitting,
    PacketState.sent => l10n.emergencyTransmitted,
    PacketState.deliveryConfirmed => l10n.deliveryConfirmed,
    PacketState.failed => l10n.emergencyFailed,
  };
}

String physioContextLabel(AppLocalizations l10n, String? context) {
  return switch (context) {
    'rest' => l10n.physioContextRest,
    'exertion' => l10n.physioContextExertion,
    'elevated_load' => l10n.physioContextElevatedLoad,
    null => l10n.unavailable,
    final other => other,
  };
}

String reasonLabel(AppLocalizations l10n, RiskReasonCode code) {
  return switch (code) {
    RiskReasonCode.hrAboveBaseline => l10n.reasonHrAboveBaseline,
    RiskReasonCode.spo2BelowBaseline => l10n.reasonSpo2BelowBaseline,
    RiskReasonCode.prolongedActivity => l10n.reasonProlongedActivity,
    RiskReasonCode.highHrLowMovement => l10n.reasonHighHrLowMovement,
    RiskReasonCode.environmentalStress => l10n.reasonEnvironmentalStress,
    RiskReasonCode.limitedSensors => l10n.reasonLimitedSensors,
    RiskReasonCode.insufficientHistory => l10n.reasonInsufficientHistory,
    RiskReasonCode.possibleFallSequence => l10n.reasonPossibleFall,
    RiskReasonCode.modelExertionContext => l10n.reasonModelExertion,
    RiskReasonCode.modelElevatedLoadContext => l10n.reasonModelElevatedLoad,
  };
}

String sensorSourceKindLabel(AppLocalizations l10n, SensorSourceKind? kind) {
  return switch (kind) {
    SensorSourceKind.simulation => l10n.sensorSourceSimulation,
    SensorSourceKind.dataset => l10n.sensorSourceDataset,
    SensorSourceKind.wearable => l10n.sensorSourceWearable,
    SensorSourceKind.device => l10n.sensorSourceDevice,
    null => l10n.unavailable,
  };
}

String fallCheckLabel(AppLocalizations l10n, String mode) {
  return mode == 'trained-window'
      ? l10n.fallCheckOnDevice
      : l10n.fallCheckSimulated;
}

String fallDetectionPublicLabel(AppLocalizations l10n, String mode) {
  return mode == 'trained-window'
      ? l10n.fallCheckOnDevice
      : l10n.fallDetectionSimulated;
}

String eventTypeLabel(AppLocalizations l10n, String eventType) {
  return switch (eventType) {
    'possible_fall' => l10n.eventTypePossibleFall,
    'physiological_deterioration' => l10n.eventTypeDeterioration,
    _ => eventType,
  };
}

String locationSourceLabel(AppLocalizations l10n, LocationSource? source) {
  return switch (source) {
    LocationSource.gps => l10n.gpsLocation,
    LocationSource.demonstration => l10n.demonstrationLocation,
    LocationSource.lastKnown => l10n.lastKnownLocation,
    LocationSource.unavailable || null => l10n.locationUnavailable,
  };
}

String heartRateTrail(AppLocalizations l10n, List<double> rates) {
  if (rates.isEmpty) {
    return l10n.unavailable;
  }
  final values = rates.map((rate) => rate.toStringAsFixed(0)).join(' · ');
  return '$values ${l10n.bpmUnit}';
}

String nowVersusUsual(
  AppLocalizations l10n,
  double? current,
  double? usual,
  String unit,
) {
  final currentText = current == null
      ? l10n.unavailable
      : current.toStringAsFixed(0);
  final usualText = usual == null ? l10n.unavailable : usual.toStringAsFixed(0);
  return '$currentText / $usualText $unit';
}

String disasterLabel(AppLocalizations l10n, DisasterType? type) {
  return switch (type) {
    DisasterType.flood => l10n.flood,
    null => l10n.unavailable,
    final other => other.name,
  };
}

String guidanceLabel(AppLocalizations l10n, DisasterGuidanceCode code) {
  return switch (code) {
    DisasterGuidanceCode.moveSafer => l10n.floodAction,
    DisasterGuidanceCode.avoidWater => l10n.floodAvoidWater,
    DisasterGuidanceCode.avoidElectrical => l10n.floodAvoidElectrical,
    DisasterGuidanceCode.followOfficial => l10n.floodFollowGuidance,
    DisasterGuidanceCode.doNotAssumeAltitude => l10n.floodDoNotAssumeAltitude,
    DisasterGuidanceCode.avoidBridges => l10n.floodAvoidBridges,
    DisasterGuidanceCode.conserveBattery => l10n.floodConserveBattery,
    DisasterGuidanceCode.keepCommunication => l10n.floodKeepCommunication,
  };
}

String compassWord(AppLocalizations l10n, String compass) {
  return switch (compass) {
    'N' => l10n.compassNorth,
    'NE' => l10n.compassNorthEast,
    'E' => l10n.compassEast,
    'SE' => l10n.compassSouthEast,
    'S' => l10n.compassSouth,
    'SW' => l10n.compassSouthWest,
    'W' => l10n.compassWest,
    'NW' => l10n.compassNorthWest,
    _ => compass,
  };
}

String demonstrationConditionLabel(
  AppLocalizations l10n,
  DemonstrationCondition condition,
) {
  return switch (condition) {
    DemonstrationCondition.resting => l10n.conditionResting,
    DemonstrationCondition.physicalActivity => l10n.conditionPhysicalActivity,
    DemonstrationCondition.highLoad => l10n.conditionHighLoad,
    DemonstrationCondition.fallImpact => l10n.conditionFallImpact,
  };
}

String recommendationReasonLabel(AppLocalizations l10n, String code) {
  return switch (code) {
    SaferLocationReason.outsideHazard => l10n.reasonOutsideHazard,
    SaferLocationReason.openSpace => l10n.reasonOpenSpace,
    SaferLocationReason.nearestInRegion => l10n.reasonNearestInRegion,
    SaferLocationReason.underGuidanceLimit => l10n.reasonUnderGuidanceLimit,
    _ => code,
  };
}

String activationLabel(
  AppLocalizations l10n,
  DisasterActivationSource? source,
) {
  return switch (source) {
    DisasterActivationSource.officialWarning => l10n.officialWarning,
    DisasterActivationSource.userActivation => l10n.userActivation,
    DisasterActivationSource.supportedLocalDetection => l10n.localDetection,
    null => l10n.unavailable,
  };
}
