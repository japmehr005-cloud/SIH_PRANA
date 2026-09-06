import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/assistant/assistant_situation.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

abstract final class AssistantSituationCompiler {
  static AssistantSituation compile(AppSessionState state) {
    final comparison = state.risk?.comparison ??
        (state.currentSample == null
            ? null
            : HealthComparison.fromWindow(
                current: state.currentSample!,
                recent: state.recentSamples,
                baseline: state.baseline,
              ));
    final baselineReady = state.baseline?.isEstablished == true;
    final guidance = state.guidance;
    final packet = state.latestPacket;
    final sourceKind =
        comparison?.sensorSourceKind ?? state.currentSample?.sourceKind;
    final demonstration =
        state.simulationActive ||
        state.demonstrationCondition != null ||
        state.currentSample?.isSimulation == true ||
        sourceKind == SensorSourceKind.simulation ||
        sourceKind == SensorSourceKind.dataset ||
        guidance?.isDemonstrationDataset == true;
    final recent = comparison?.recentHeartRates.isNotEmpty == true
        ? comparison!.recentHeartRates
        : [
            for (final sample in state.recentSamples)
              if (sample.heartRateBpm != null) sample.heartRateBpm!,
          ];

    return AssistantSituation(
      baselineReady: baselineReady,
      usualHeartRate:
          comparison?.usualHeartRate ??
          state.baseline?.restingHeartRate?.median,
      usualSpo2: comparison?.usualSpo2 ?? state.baseline?.spo2?.median,
      currentHeartRate:
          comparison?.currentHeartRate ?? state.currentSample?.heartRateBpm,
      currentSpo2:
          comparison?.currentSpo2 ?? state.currentSample?.spo2Percent,
      recentHeartRates: recent,
      windowHeartRateMean: comparison?.windowHeartRateMean,
      contextLabel: _publicContext(state.risk?.contextLabel),
      riskReasons: state.risk?.reasons ?? const [],
      riskInsufficient: state.risk?.insufficientData ?? false,
      riskElevated:
          state.risk != null &&
          !state.risk!.insufficientData &&
          state.visibleRisk.rank >= RiskLevel.moderate.rank,
      phase: state.emergency.phase,
      disasterType: state.emergency.disasterType,
      fallStatus: state.fallStatus,
      placeLabel: guidance?.place.label,
      distanceMeters: guidance?.distanceMeters,
      compassLabel: guidance?.compassLabel,
      insideHazard: guidance?.insideHazard ?? false,
      locationUnknown: state.deviceLocation == null && guidance == null,
      connectivity: state.connectivity,
      packetPresent: packet != null,
      packetEventType: packet?.eventType,
      usesDemonstrationData: demonstration,
      baselineNotReady: !baselineReady,
      noDisasterActive:
          !state.emergency.phase.isEmergencyActive &&
          state.emergency.disasterType == null,
      nearbyCount: state.nearbyPeers.length,
    );
  }

  static String? _publicContext(String? label) {
    return switch (label) {
      'rest' || 'exertion' || 'elevated_load' => label,
      _ => null,
    };
  }
}
