import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HealthAssessmentRows extends StatelessWidget {
  const HealthAssessmentRows({
    super.key,
    required this.state,
    this.showExplanation = true,
    this.showFallCheck = true,
  });

  final AppSessionState state;
  final bool showExplanation;
  final bool showFallCheck;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final risk = state.risk;
    final comparison =
        risk?.comparison ??
        (state.currentSample == null
            ? null
            : HealthComparison.fromWindow(
                current: state.currentSample!,
                recent: state.recentSamples,
                baseline: state.baseline,
              ));
    final sourceKind =
        comparison?.sensorSourceKind ?? state.currentSample?.sourceKind;
    final trailRates = comparison?.recentHeartRates.isNotEmpty == true
        ? comparison!.recentHeartRates
        : [
            for (final sample in state.recentSamples)
              if (sample.heartRateBpm != null) sample.heartRateBpm!,
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricRow(
          label: l10n.sensorSourceLabel,
          value: sensorSourceKindLabel(l10n, sourceKind),
          icon: Icons.sensors,
        ),
        MetricRow(
          label: l10n.recentHeartRate,
          value: heartRateTrail(l10n, trailRates),
          icon: Icons.show_chart,
        ),
        MetricRow(
          label: l10n.heartRateNowUsual,
          value: nowVersusUsual(
            l10n,
            comparison?.currentHeartRate ?? state.currentSample?.heartRateBpm,
            comparison?.usualHeartRate ??
                state.baseline?.restingHeartRate?.median,
            l10n.bpmUnit,
          ),
          icon: Icons.favorite_border,
        ),
        MetricRow(
          label: l10n.spo2NowUsual,
          value: nowVersusUsual(
            l10n,
            comparison?.currentSpo2 ?? state.currentSample?.spo2Percent,
            comparison?.usualSpo2 ?? state.baseline?.spo2?.median,
            l10n.percentUnit,
          ),
          icon: Icons.air,
        ),
        MetricRow(
          label: l10n.windowHeartRate,
          value: comparison?.windowHeartRateMean == null
              ? l10n.unavailable
              : '${comparison!.windowHeartRateMean!.toStringAsFixed(0)} ${l10n.bpmUnit}',
          icon: Icons.timeline,
        ),
        MetricRow(
          label: l10n.healthAssessment,
          value: risk == null
              ? l10n.unavailable
              : physioContextLabel(l10n, risk.contextLabel),
          icon: Icons.monitor_heart_outlined,
        ),
        MetricRow(
          label: l10n.assessmentConfidence,
          value: risk?.contextConfidence == null
              ? l10n.unavailable
              : '${(risk!.contextConfidence! * 100).toStringAsFixed(0)}%',
          icon: Icons.verified_outlined,
        ),
        if (risk != null)
          MetricRow(
            label: l10n.healthStatus,
            value: l10n.assessmentFromReadings,
            icon: Icons.health_and_safety_outlined,
          ),
        if (showFallCheck)
          MetricRow(
            label: l10n.fallCheck,
            value: fallCheckLabel(l10n, state.fallDetectionMode),
            icon: Icons.accessibility_new,
          ),
        if (showExplanation) _AssessmentExplanation(risk: risk, l10n: l10n),
      ],
    );
  }
}

class _AssessmentExplanation extends StatelessWidget {
  const _AssessmentExplanation({required this.risk, required this.l10n});

  final RiskAssessment? risk;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final lines = _lines();
    if (lines.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: AarogyaSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.assessmentWhyHeading,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AarogyaColors.textPrimary,
            ),
          ),
          const SizedBox(height: AarogyaSpacing.sm),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: AarogyaSpacing.xs),
              child: Text(line),
            ),
        ],
      ),
    );
  }

  List<String> _lines() {
    final assessment = risk;
    if (assessment == null) {
      return const [];
    }
    final comparison = assessment.comparison;
    final lines = <String>[];
    if (comparison?.currentHeartRate != null &&
        comparison?.usualHeartRate != null) {
      lines.add(
        l10n.alertHrVsBaseline(
          comparison!.currentHeartRate!.toStringAsFixed(0),
          comparison.usualHeartRate!.toStringAsFixed(0),
        ),
      );
    }
    if (comparison?.currentSpo2 != null && comparison?.usualSpo2 != null) {
      lines.add(
        l10n.alertSpo2VsBaseline(
          comparison!.currentSpo2!.toStringAsFixed(0),
          comparison.usualSpo2!.toStringAsFixed(0),
        ),
      );
    }
    if (assessment.contextLabel != null) {
      lines.add(
        l10n.alertModelDetected(
          physioContextLabel(l10n, assessment.contextLabel),
          assessment.contextConfidence == null
              ? l10n.unavailable
              : (assessment.contextConfidence! * 100).toStringAsFixed(0),
        ),
      );
      lines.add(l10n.modelPipelineNote);
    }
    final elevated = assessment.level.rank >= RiskLevel.moderate.rank;
    if (elevated) {
      lines.add(l10n.alertRiskCombined);
    }
    for (final reason in assessment.reasons.take(3)) {
      final label = reasonLabel(l10n, reason);
      if (!lines.contains(label)) {
        lines.add(label);
      }
    }
    return lines;
  }
}

class PacketModelRows extends StatelessWidget {
  const PacketModelRows({super.key, required this.packet});

  final EmergencyPacket packet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sourceKind = SensorSourceKindX.tryParse(packet.sensorSourceKind);
    return Column(
      children: [
        MetricRow(
          label: l10n.healthAssessment,
          value: physioContextLabel(l10n, packet.contextLabel),
          icon: Icons.monitor_heart_outlined,
        ),
        MetricRow(
          label: l10n.assessmentConfidence,
          value: packet.contextConfidence == null
              ? l10n.unavailable
              : '${(packet.contextConfidence! * 100).toStringAsFixed(0)}%',
          icon: Icons.verified_outlined,
        ),
        MetricRow(
          label: l10n.heartRateNowUsual,
          value: nowVersusUsual(
            l10n,
            packet.heartRateBpm,
            packet.baselineHeartRate,
            l10n.bpmUnit,
          ),
          icon: Icons.favorite_border,
        ),
        MetricRow(
          label: l10n.spo2NowUsual,
          value: nowVersusUsual(
            l10n,
            packet.spo2Percent,
            packet.baselineSpo2,
            l10n.percentUnit,
          ),
          icon: Icons.air,
        ),
        MetricRow(
          label: l10n.healthStatus,
          value: l10n.assessmentFromReadings,
          icon: Icons.health_and_safety_outlined,
        ),
        MetricRow(
          label: l10n.sensorSourceLabel,
          value: sensorSourceKindLabel(l10n, sourceKind),
          icon: Icons.sensors,
        ),
        MetricRow(
          label: l10n.fallDetectionMode,
          value: fallDetectionPublicLabel(l10n, packet.fallDetectionMode),
          icon: Icons.accessibility_new,
        ),
      ],
    );
  }
}

class TechnicalInformationRows extends StatelessWidget {
  const TechnicalInformationRows({
    super.key,
    required this.state,
    this.userId,
    this.deviceId,
  });

  final AppSessionState state;
  final String? userId;
  final String? deviceId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final risk = state.risk;
    final packet = state.latestPacket;
    return Column(
      children: [
        MetricRow(
          label: l10n.userIdentifier,
          value: userId ?? l10n.unavailable,
          icon: Icons.person_outline,
        ),
        MetricRow(
          label: l10n.deviceIdentifier,
          value: deviceId ?? packet?.originDeviceId ?? l10n.unavailable,
          icon: Icons.smartphone_outlined,
        ),
        MetricRow(
          label: l10n.assistantTechnicalTitle,
          value: l10n.assistantTechnicalBody,
          icon: Icons.help_outline,
        ),
        MetricRow(
          label: l10n.engineVersion,
          value: state.engineVersion ?? l10n.unavailable,
          icon: Icons.memory_outlined,
        ),
        MetricRow(
          label: l10n.inferenceSource,
          value: risk?.usedTrainedModel == true
              ? l10n.inferenceTrainedModel
              : l10n.inferenceRulesOnly,
          icon: Icons.hub_outlined,
        ),
        if (risk != null)
          MetricRow(
            label: l10n.riskInputs,
            value: l10n.riskInputsValue(
              risk.rulesScore.toStringAsFixed(0),
              risk.modelContribution.toStringAsFixed(0),
            ),
            icon: Icons.account_tree_outlined,
          ),
        MetricRow(
          label: l10n.eventId,
          value: packet?.eventId ?? l10n.unavailable,
          icon: Icons.badge_outlined,
        ),
        MetricRow(
          label: l10n.fallDetectionMode,
          value: packet?.fallDetectionMode ?? state.fallDetectionMode,
          icon: Icons.accessibility_new,
        ),
        MetricRow(
          label: l10n.location,
          value: state.deviceLocation == null
              ? l10n.unavailable
              : locationSourceLabel(l10n, state.deviceLocation!.source),
          icon: Icons.my_location,
        ),
        MetricRow(
          label: l10n.nearbyAarogyaUsers,
          value: state.transportId == 'nearby-demo-relay'
              ? l10n.nearbyRelayTechnical
              : state.transportId == 'simulated-mesh'
              ? l10n.inMemoryTransportTechnical
              : (state.transportId ?? l10n.unavailable),
          icon: Icons.hub_outlined,
        ),
        if (packet != null)
          MetricRow(
            label: l10n.riskScoreLabel,
            value: packet.riskScore?.toStringAsFixed(0) ?? l10n.unavailable,
            icon: Icons.speed_outlined,
          ),
      ],
    );
  }
}
