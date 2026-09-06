import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/inference_status_rows.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/metric_tile.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/features/communication/presentation/nearby_users_card.dart';
import 'package:aarogya/features/disaster/domain/disaster_guidance.dart';
import 'package:aarogya/features/health/presentation/connected_device_card.dart';
import 'package:aarogya/features/location/presentation/safer_location_map.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DemoStageBody extends StatelessWidget {
  const DemoStageBody({super.key, required this.stage, required this.state});

  final int stage;
  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      1 => _BaselineBody(state: state),
      2 => _FloodWarningBody(state: state),
      3 => _DisasterActiveBody(state: state),
      4 => _OfflineBody(state: state),
      5 => _SurvivalBody(state: state),
      6 => _HealthEmergencyBody(state: state),
      7 => _PacketBody(state: state, emphasizeLocal: true),
      8 => _RestoreBody(state: state),
      _ => _PacketBody(state: state, emphasizeLocal: false),
    };
  }
}

String _vital(double? value, String unit, AppLocalizations l10n) {
  if (value == null) {
    return l10n.unavailable;
  }
  return '${value.toStringAsFixed(0)} $unit';
}

String _location(AppSessionState state, AppLocalizations l10n) {
  final sample = state.currentSample;
  if (sample?.hasLocation == true) {
    return '${sample!.latitude!.toStringAsFixed(3)}, ${sample.longitude!.toStringAsFixed(3)}';
  }
  return l10n.demoLocationKathmandu;
}

String _sensors(AppSessionState state, AppLocalizations l10n) {
  final sample = state.currentSample;
  if (sample == null) {
    return l10n.unavailable;
  }
  final available = <String>[
    if (sample.heartRateBpm != null) l10n.heartRate,
    if (sample.spo2Percent != null) l10n.spo2,
    if (sample.temperatureC != null) l10n.temperature,
    if (sample.accelMagnitude != null) l10n.activity,
  ];
  return available.isEmpty ? l10n.unavailable : available.join(', ');
}

class _BaselineBody extends StatelessWidget {
  const _BaselineBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sample = state.currentSample;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricTileGrid(
          tiles: [
            MetricTile(
              label: l10n.heartRate,
              value: _vital(sample?.heartRateBpm, l10n.bpmUnit, l10n),
              icon: Icons.favorite_border,
            ),
            MetricTile(
              label: l10n.spo2,
              value: _vital(sample?.spo2Percent, l10n.percentUnit, l10n),
              icon: Icons.air,
            ),
            MetricTile(
              label: l10n.temperature,
              value: _vital(sample?.temperatureC, l10n.celsiusUnit, l10n),
              icon: Icons.thermostat,
            ),
            MetricTile(
              label: l10n.activity,
              value: movementLabel(l10n, sample?.movement),
              icon: Icons.directions_walk,
            ),
          ],
        ),
        const SizedBox(height: AarogyaSpacing.md),
        InfoCard(
          child: Column(
            children: [
              MetricRow(
                label: l10n.personalBaseline,
                value: state.baseline?.isEstablished == true
                    ? l10n.baselineReady
                    : l10n.baselineNotReady,
                icon: Icons.timeline,
              ),
              MetricRow(
                label: l10n.confidenceLabel,
                value: '${state.baseline?.sampleCount ?? 0}',
                icon: Icons.history,
              ),
              MetricRow(
                label: l10n.sensorAvailability,
                value: _sensors(state, l10n),
                icon: Icons.sensors,
              ),
              MetricRow(
                label: l10n.connectivity,
                value: connectivityLabel(l10n, state.connectivity),
                icon: Icons.wifi,
              ),
              HealthAssessmentRows(state: state, showFallCheck: false),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        ConnectedDeviceCard(state: state),
      ],
    );
  }
}

class _FloodWarningBody extends StatelessWidget {
  const _FloodWarningBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final issued =
        state.emergency.phase.index >= EmergencyPhase.disasterAlert.index;
    if (!issued) {
      return InfoCard(child: Text(l10n.demoStage2Body));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AarogyaColors.warningSoft,
            border: Border.all(color: AarogyaColors.warning),
            borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AarogyaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.floodWarningIssued,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AarogyaColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AarogyaSpacing.sm),
                MetricRow(
                  label: l10n.floodSeverity,
                  value: l10n.floodSeverityHigh,
                  icon: Icons.priority_high,
                ),
                MetricRow(
                  label: l10n.eventTimestamp,
                  value: state.emergency.updatedAt.toLocal().toString(),
                  icon: Icons.schedule,
                ),
                MetricRow(
                  label: l10n.affectedArea,
                  value: _location(state, l10n),
                  icon: Icons.location_on_outlined,
                ),
                MetricRow(
                  label: l10n.activationSource,
                  value: state.emergency.activationSource == null
                      ? l10n.unavailable
                      : l10n.officialWarning,
                  icon: Icons.campaign_outlined,
                ),
                MetricRow(
                  label: l10n.immediateAction,
                  value: l10n.floodAction,
                  icon: Icons.north,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        SaferLocationMap(state: state),
      ],
    );
  }
}

class _DisasterActiveBody extends StatelessWidget {
  const _DisasterActiveBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final codes = DisasterGuidanceCatalog.forType(state.emergency.disasterType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final code in codes)
                Padding(
                  padding: const EdgeInsets.only(bottom: AarogyaSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AarogyaColors.primary,
                      ),
                      const SizedBox(width: AarogyaSpacing.sm),
                      Expanded(child: Text(guidanceLabel(l10n, code))),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        SaferLocationMap(state: state),
      ],
    );
  }
}

class _OfflineBody extends StatelessWidget {
  const _OfflineBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = [
      (l10n.networkLabel, l10n.connectivityOffline),
      (l10n.capabilityLocalMonitoring, l10n.capabilityActive),
      (l10n.capabilityLocalInference, l10n.capabilityActive),
      (l10n.capabilityLocalStorage, l10n.capabilityActive),
      (l10n.capabilityDisasterGuidance, l10n.capabilityAvailable),
      (l10n.capabilityEmergencyProcessing, l10n.capabilityAvailable),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AarogyaColors.dangerSoft,
            border: Border.all(color: AarogyaColors.danger),
            borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AarogyaSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: AarogyaColors.danger),
                const SizedBox(width: AarogyaSpacing.md),
                Text(
                  connectivityLabel(l10n, state.connectivity),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AarogyaColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        InfoCard(
          child: Column(
            children: [
              for (final row in rows)
                MetricRow(
                  label: row.$1,
                  value: row.$2,
                  icon: Icons.check_circle_outline,
                ),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.sm),
        Text(
          l10n.simulatedConnectivity,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AarogyaColors.textSecondary),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        SaferLocationMap(state: state),
      ],
    );
  }
}

class _SurvivalBody extends StatelessWidget {
  const _SurvivalBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sample = state.currentSample;
    return Column(
      children: [
        MetricTileGrid(
          tiles: [
            MetricTile(
              label: l10n.heartRate,
              value: _vital(sample?.heartRateBpm, l10n.bpmUnit, l10n),
              icon: Icons.favorite_border,
            ),
            MetricTile(
              label: l10n.spo2,
              value: _vital(sample?.spo2Percent, l10n.percentUnit, l10n),
              icon: Icons.air,
            ),
            MetricTile(
              label: l10n.temperature,
              value: _vital(sample?.temperatureC, l10n.celsiusUnit, l10n),
              icon: Icons.thermostat,
            ),
            MetricTile(
              label: l10n.activity,
              value: movementLabel(l10n, sample?.movement),
              icon: Icons.directions_walk,
            ),
          ],
        ),
        const SizedBox(height: AarogyaSpacing.md),
        InfoCard(
          child: Column(
            children: [
              MetricRow(
                label: l10n.riskLevel,
                value: riskLabel(l10n, state.visibleRisk),
                icon: Icons.shield_outlined,
              ),
              MetricRow(
                label: l10n.battery,
                value: _vital(sample?.batteryPercent, l10n.percentUnit, l10n),
                icon: Icons.battery_std_outlined,
              ),
              MetricRow(
                label: l10n.location,
                value: _location(state, l10n),
                icon: Icons.location_on_outlined,
              ),
              MetricRow(
                label: l10n.connectivity,
                value: connectivityLabel(l10n, state.connectivity),
                icon: Icons.wifi_off,
              ),
              HealthAssessmentRows(state: state),
            ],
          ),
        ),
      ],
    );
  }
}

class _HealthEmergencyBody extends StatelessWidget {
  const _HealthEmergencyBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lit = _litFallSteps(state);
    final steps = [
      l10n.fallStepSpike,
      l10n.fallStepImpact,
      l10n.fallStepOrientation,
      l10n.fallStepInactivity,
      l10n.fallStepConfirmation,
      l10n.fallStepEmergency,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricTileGrid(
          tiles: [
            MetricTile(
              label: l10n.heartRate,
              value: _vital(
                state.currentSample?.heartRateBpm,
                l10n.bpmUnit,
                l10n,
              ),
              icon: Icons.favorite_border,
            ),
            MetricTile(
              label: l10n.spo2,
              value: _vital(
                state.currentSample?.spo2Percent,
                l10n.percentUnit,
                l10n,
              ),
              icon: Icons.air,
            ),
            MetricTile(
              label: l10n.temperature,
              value: _vital(
                state.currentSample?.temperatureC,
                l10n.celsiusUnit,
                l10n,
              ),
              icon: Icons.thermostat,
            ),
            MetricTile(
              label: l10n.activity,
              value: movementLabel(l10n, state.currentSample?.movement),
              icon: Icons.directions_walk,
            ),
          ],
        ),
        const SizedBox(height: AarogyaSpacing.md),
        InfoCard(child: HealthAssessmentRows(state: state)),
        const SizedBox(height: AarogyaSpacing.md),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricRow(
                label: l10n.fallCheck,
                value: fallCheckLabel(l10n, state.fallDetectionMode),
                icon: Icons.accessibility_new,
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              for (var i = 0; i < steps.length; i++) ...[
                Row(
                  children: [
                    Icon(
                      lit > i
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: lit > i
                          ? AarogyaColors.danger
                          : AarogyaColors.textSecondary,
                    ),
                    const SizedBox(width: AarogyaSpacing.sm),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: lit > i
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: lit > i
                              ? AarogyaColors.textPrimary
                              : AarogyaColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 9, top: 2, bottom: 2),
                    child: Container(
                      width: 2,
                      height: 12,
                      color: lit > i + 1
                          ? AarogyaColors.danger
                          : AarogyaColors.border,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  int _litFallSteps(AppSessionState state) {
    if (state.latestPacket != null ||
        state.fallStatus == FallStatus.criticalUnconfirmed) {
      return 6;
    }
    if (state.fallStatus == FallStatus.awaitingConfirmation) {
      return 5;
    }
    if (state.fallStatus == FallStatus.possible) {
      return 3;
    }
    return 0;
  }
}

class _PacketBody extends StatelessWidget {
  const _PacketBody({required this.state, required this.emphasizeLocal});

  final AppSessionState state;
  final bool emphasizeLocal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final packet = state.latestPacket;
    if (packet == null) {
      return InfoCard(child: Text(l10n.noEmergencyPackets));
    }
    final localOnly = emphasizeLocal && !packet.state.canShowTransmitted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (localOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: AarogyaSpacing.md),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AarogyaColors.warningSoft,
                border: Border.all(color: AarogyaColors.warning),
                borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AarogyaSpacing.md),
                child: Text(
                  l10n.packetStoredLocally,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AarogyaColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        _PacketSummary(
          packet: packet,
          connectivity: state.connectivity,
          temperature: state.currentSample?.temperatureC,
        ),
      ],
    );
  }
}

class _RestoreBody extends StatelessWidget {
  const _RestoreBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final packet = state.latestPacket;
    final current = packet?.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          child: Column(
            children: [
              MetricRow(
                label: l10n.connectivity,
                value: connectivityLabel(l10n, state.connectivity),
                icon: state.connectivity == ConnectivityStatus.online
                    ? Icons.wifi
                    : Icons.wifi_off,
              ),
              _TransitRow(
                label: l10n.packetLocalOnly,
                active:
                    current == PacketState.created ||
                    current == PacketState.stored ||
                    current == PacketState.failed,
              ),
              _TransitRow(
                label: l10n.packetPending,
                active:
                    current == PacketState.queued ||
                    current == PacketState.transmitting,
              ),
              _TransitRow(
                label: l10n.packetSentDelivered,
                active: current?.canShowTransmitted == true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        NearbyUsersCard(state: state),
        if (packet != null) ...[
          const SizedBox(height: AarogyaSpacing.md),
          _PacketSummary(
            packet: packet,
            connectivity: state.connectivity,
            temperature: state.currentSample?.temperatureC,
          ),
        ],
      ],
    );
  }
}

class _TransitRow extends StatelessWidget {
  const _TransitRow({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AarogyaSpacing.sm),
      child: Row(
        children: [
          Icon(
            active ? Icons.arrow_right_alt : Icons.remove,
            color: active ? AarogyaColors.safe : AarogyaColors.textSecondary,
          ),
          const SizedBox(width: AarogyaSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              color: active
                  ? AarogyaColors.textPrimary
                  : AarogyaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PacketSummary extends StatelessWidget {
  const _PacketSummary({
    required this.packet,
    required this.connectivity,
    this.temperature,
  });

  final EmergencyPacket packet;
  final ConnectivityStatus connectivity;
  final double? temperature;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InfoCard(
      child: Column(
        children: [
          MetricRow(
            label: l10n.eventId,
            value: packet.eventId,
            icon: Icons.badge_outlined,
          ),
          MetricRow(
            label: l10n.eventType,
            value: packet.eventType,
            icon: Icons.assignment_outlined,
          ),
          MetricRow(
            label: l10n.eventTimestamp,
            value: packet.timestamp.toLocal().toString(),
            icon: Icons.schedule,
          ),
          MetricRow(
            label: l10n.location,
            value: packet.locationAvailable
                ? '${packet.latitude!.toStringAsFixed(3)}, ${packet.longitude!.toStringAsFixed(3)}'
                : l10n.locationUnavailable,
            icon: Icons.location_on_outlined,
          ),
          MetricRow(
            label: l10n.riskLevel,
            value: riskLabel(l10n, packet.riskLevel),
            icon: Icons.shield_outlined,
          ),
          MetricRow(
            label: l10n.heartRate,
            value: packet.heartRateBpm?.toStringAsFixed(0) ?? l10n.unavailable,
            icon: Icons.favorite_border,
          ),
          MetricRow(
            label: l10n.spo2,
            value: packet.spo2Percent?.toStringAsFixed(0) ?? l10n.unavailable,
            icon: Icons.air,
          ),
          MetricRow(
            label: l10n.temperature,
            value: temperature?.toStringAsFixed(0) ?? l10n.unavailable,
            icon: Icons.thermostat,
          ),
          MetricRow(
            label: l10n.battery,
            value:
                packet.batteryPercent?.toStringAsFixed(0) ?? l10n.unavailable,
            icon: Icons.battery_std_outlined,
          ),
          MetricRow(
            label: l10n.connectivity,
            value: connectivityLabel(l10n, connectivity),
            icon: Icons.wifi,
          ),
          MetricRow(
            label: l10n.packetState,
            value: packetLabel(l10n, packet.state),
            icon: Icons.outgoing_mail,
          ),
          PacketModelRows(packet: packet),
        ],
      ),
    );
  }
}
