import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/inference_status_rows.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/app/widgets/status_panel.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/assistant/presentation/ask_assistant_button.dart';
import 'package:aarogya/features/communication/presentation/nearby_users_card.dart';
import 'package:aarogya/features/disaster/domain/disaster_guidance.dart';
import 'package:aarogya/features/health/presentation/connected_device_card.dart';
import 'package:aarogya/features/health/presentation/demonstration_condition_chips.dart';
import 'package:aarogya/features/location/presentation/safer_location_map.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);

    return session.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: Center(child: Text(l10n.loading)),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: Padding(
          padding: const EdgeInsets.all(AarogyaSpacing.page),
          child: StatusPanel(
            title: l10n.errorContinue,
            body: l10n.continueUsing,
            icon: Icons.error_outline,
            level: RiskLevel.high,
          ),
        ),
      ),
      data: (state) => _HomeBody(state: state, embedded: embedded),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.state, this.embedded = false});

  final AppSessionState state;
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final bottomPad = wide ? AarogyaSpacing.page : AarogyaSpacing.page + 32;
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AarogyaSpacing.page,
            AarogyaSpacing.page,
            AarogyaSpacing.page,
            bottomPad,
          ),
          children: [
            if (_isEmergencyLayout(state))
              _EmergencySections(state: state)
            else
              _DashboardSections(state: state),
          ],
        ),
      ),
    );
    if (embedded) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        title: Row(
          children: [
            const BrandMark(height: 40, compact: true),
            const SizedBox(width: AarogyaSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.healthNav),
                  Text(
                    l10n.productTagline,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AarogyaColors.textSecondary),
                  ),
                  if (ref.watch(dependenciesProvider).accounts.current
                      case final account?)
                    Text(
                      account.displayName ?? account.email,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AarogyaColors.textSecondary),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: content,
    );
  }

  bool _isEmergencyLayout(AppSessionState state) {
    return state.emergency.phase.isEmergencyActive ||
        state.fallStatus == FallStatus.awaitingConfirmation ||
        state.latestPacket != null;
  }
}

class _DashboardSections extends StatelessWidget {
  const _DashboardSections({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(l10n.yourHealth),
        ConnectedDeviceCard(state: state),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.personalBaseline),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.baseline?.isEstablished == true
                    ? l10n.baselineReady
                    : l10n.baselineNotReady,
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              Text(
                '${l10n.baselineConfidence}: ${state.baseline?.sampleCount ?? 0}',
              ),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.healthAssessment),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_assessmentSentence(l10n, state)),
              const SizedBox(height: AarogyaSpacing.sm),
              HealthAssessmentRows(state: state),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.md),
        const AskAssistantButton(),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.currentSituation),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricRow(
                label: l10n.currentSituation,
                value: _situationLabel(l10n, state),
                icon: Icons.monitor_heart_outlined,
              ),
              MetricRow(
                label: l10n.connectivity,
                value: connectivityLabel(l10n, state.connectivity),
                icon: state.connectivity == ConnectivityStatus.online
                    ? Icons.wifi
                    : Icons.wifi_off,
              ),
              Text(l10n.localMonitoringActive),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.currentLocation),
        SaferLocationMap(state: state),
        if (state.nearbyPeers.isNotEmpty ||
            state.receivedPackets.isNotEmpty) ...[
          const SizedBox(height: AarogyaSpacing.lg),
          SectionHeader(l10n.nearbyAarogyaUsers),
          NearbyUsersCard(state: state),
        ],
      ],
    );
  }

  String _situationLabel(AppLocalizations l10n, AppSessionState state) {
    if (state.emergency.phase.isEmergencyActive) {
      return phaseLabel(l10n, state.emergency.phase);
    }
    if (state.connectivity != ConnectivityStatus.online) {
      return l10n.limitedConnectivity;
    }
    return phaseLabel(l10n, state.emergency.phase);
  }

  String _assessmentSentence(AppLocalizations l10n, AppSessionState state) {
    if (state.risk != null &&
        !state.risk!.insufficientData &&
        state.visibleRisk.rank >= RiskLevel.moderate.rank) {
      return l10n.readingsDifferFromBaseline;
    }
    return l10n.assessmentFromReadings;
  }
}

class _EmergencySections extends ConsumerWidget {
  const _EmergencySections({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusPanel(
          title: l10n.situationEmergency,
          body: phaseLabel(l10n, state.emergency.phase),
          icon: Icons.emergency_outlined,
          level: state.visibleRisk.rank >= RiskLevel.high.rank
              ? state.visibleRisk
              : RiskLevel.high,
        ),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.whatHappened),
        InfoCard(child: Text(_whatHappened(l10n, state))),
        if (state.fallStatus == FallStatus.awaitingConfirmation) ...[
          const SizedBox(height: AarogyaSpacing.md),
          _FallConfirmationPanel(state: state),
        ],
        if (state.fallCheckCancelled) ...[
          const SizedBox(height: AarogyaSpacing.md),
          Text(l10n.fallCheckCancelled),
        ],
        const SizedBox(height: AarogyaSpacing.md),
        const AskAssistantButton(),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.currentCondition),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_assessmentSentence(l10n, state)),
              const SizedBox(height: AarogyaSpacing.sm),
              MetricRow(
                label: l10n.heartRate,
                value: state.currentSample?.heartRateBpm == null
                    ? l10n.unavailable
                    : '${state.currentSample!.heartRateBpm!.toStringAsFixed(0)} ${l10n.bpmUnit}',
                icon: Icons.favorite_border,
              ),
              MetricRow(
                label: l10n.bloodOxygen,
                value: state.currentSample?.spo2Percent == null
                    ? l10n.unavailable
                    : '${state.currentSample!.spo2Percent!.toStringAsFixed(0)} ${l10n.percentUnit}',
                icon: Icons.air,
              ),
              HealthAssessmentRows(state: state, showFallCheck: true),
              const SizedBox(height: AarogyaSpacing.md),
              DemonstrationConditionChips(state: state),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.recommendedAction),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.emergency.phase.index >=
                  EmergencyPhase.disasterAlert.index)
                for (final code in DisasterGuidanceCatalog.forType(
                  state.emergency.disasterType,
                ))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AarogyaSpacing.sm),
                    child: Text(guidanceLabel(l10n, code)),
                  ),
              if (state.guidance != null)
                Text(
                  l10n.distanceAndBearing(
                    state.guidance!.distanceMeters.toStringAsFixed(0),
                    state.guidance!.compassLabel,
                  ),
                )
              else
                Text(l10n.noNearbySaferLocation),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.currentLocation),
        SaferLocationMap(state: state),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.assistanceStatus),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricRow(
                label: l10n.connectivity,
                value: connectivityLabel(l10n, state.connectivity),
                icon: state.connectivity == ConnectivityStatus.online
                    ? Icons.wifi
                    : Icons.wifi_off,
              ),
              if (state.latestPacket != null)
                Text(packetLabel(l10n, state.latestPacket!.state))
              else
                Text(l10n.localMonitoringActive),
            ],
          ),
        ),
        const SizedBox(height: AarogyaSpacing.lg),
        SectionHeader(l10n.nearbyAarogyaUsers),
        NearbyUsersCard(state: state),
      ],
    );
  }

  String _whatHappened(AppLocalizations l10n, AppSessionState state) {
    if (state.fallStatus != FallStatus.none) {
      return l10n.possibleFallDetected;
    }
    if (state.latestPacket != null) {
      return l10n.emergencyEventRecorded;
    }
    if (state.emergency.phase.index >= EmergencyPhase.disasterAlert.index) {
      return l10n.floodWarningIssued;
    }
    return l10n.elevatedHealthRisk;
  }

  String _assessmentSentence(AppLocalizations l10n, AppSessionState state) {
    if (state.fallStatus != FallStatus.none) {
      return l10n.possibleFallDetected;
    }
    if (state.risk != null &&
        !state.risk!.insufficientData &&
        state.visibleRisk.rank >= RiskLevel.moderate.rank) {
      return l10n.readingsDifferFromBaseline;
    }
    return l10n.elevatedHealthRisk;
  }
}

class _FallConfirmationPanel extends ConsumerStatefulWidget {
  const _FallConfirmationPanel({required this.state});

  final AppSessionState state;

  @override
  ConsumerState<_FallConfirmationPanel> createState() =>
      _FallConfirmationPanelState();
}

class _FallConfirmationPanelState
    extends ConsumerState<_FallConfirmationPanel> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deadline = widget.state.fallConfirmationDeadline;
    final remaining = deadline?.difference(DateTime.now());
    final seconds = remaining == null
        ? ''
        : remaining.isNegative
        ? '0'
        : remaining.inSeconds.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusPanel(
          title: l10n.possibleFallDetected,
          body: seconds.isEmpty
              ? l10n.fallCheckOnDevice
              : '${l10n.fallCheckOnDevice} · $seconds',
          icon: Icons.personal_injury_outlined,
          level: RiskLevel.high,
        ),
        const SizedBox(height: AarogyaSpacing.md),
        FilledButton(
          onPressed: () {
            unawaited(ref.read(dependenciesProvider).runtime.userIsOk());
          },
          child: Text(l10n.iAmOk),
        ),
        const SizedBox(height: AarogyaSpacing.sm),
        OutlinedButton(
          onPressed: () {
            unawaited(ref.read(dependenciesProvider).runtime.userNeedsHelp());
          },
          child: Text(l10n.iNeedHelp),
        ),
      ],
    );
  }
}
