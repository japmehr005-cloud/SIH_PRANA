import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';

/// Compiled session facts for the on-device assistant. No inference.
final class AssistantSituation {
  const AssistantSituation({
    required this.baselineReady,
    required this.usualHeartRate,
    required this.usualSpo2,
    required this.currentHeartRate,
    required this.currentSpo2,
    required this.recentHeartRates,
    required this.windowHeartRateMean,
    required this.contextLabel,
    required this.riskReasons,
    required this.riskInsufficient,
    required this.riskElevated,
    required this.phase,
    required this.disasterType,
    required this.fallStatus,
    required this.placeLabel,
    required this.distanceMeters,
    required this.compassLabel,
    required this.insideHazard,
    required this.locationUnknown,
    required this.connectivity,
    required this.packetPresent,
    required this.packetEventType,
    required this.usesDemonstrationData,
    required this.baselineNotReady,
    required this.noDisasterActive,
    this.nearbyCount = 0,
  });

  final bool baselineReady;
  final double? usualHeartRate;
  final double? usualSpo2;
  final double? currentHeartRate;
  final double? currentSpo2;
  final List<double> recentHeartRates;
  final double? windowHeartRateMean;
  final String? contextLabel;
  final List<RiskReasonCode> riskReasons;
  final bool riskInsufficient;
  final bool riskElevated;
  final EmergencyPhase phase;
  final DisasterType? disasterType;
  final FallStatus fallStatus;
  final String? placeLabel;
  final double? distanceMeters;
  final String? compassLabel;
  final bool insideHazard;
  final bool locationUnknown;
  final ConnectivityStatus connectivity;
  final bool packetPresent;
  final String? packetEventType;
  final bool usesDemonstrationData;
  final bool baselineNotReady;
  final bool noDisasterActive;
  final int nearbyCount;

  bool get heartRateHigherThanUsual {
    final current = currentHeartRate;
    final usual = usualHeartRate;
    return current != null && usual != null && current > usual;
  }

  bool get heartRateLowerThanUsual {
    final current = currentHeartRate;
    final usual = usualHeartRate;
    return current != null && usual != null && current < usual;
  }

  bool get heartRateMatchesUsual {
    final current = currentHeartRate;
    final usual = usualHeartRate;
    return current != null && usual != null && current == usual;
  }

  bool get spo2LowerThanUsual {
    final current = currentSpo2;
    final usual = usualSpo2;
    return current != null && usual != null && current < usual;
  }

  bool get hasGuidance {
    return placeLabel != null && distanceMeters != null && compassLabel != null;
  }

  bool get connectivityLimited {
    return connectivity != ConnectivityStatus.online;
  }
}
