import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
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
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeOverviewScreen extends ConsumerWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);

    return session.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: Center(child: Text(l10n.loading)),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: Center(child: Text(l10n.errorContinue)),
      ),
      data: (state) => _OverviewBody(state: state),
    );
  }
}

class _OverviewBody extends ConsumerWidget {
  const _OverviewBody({required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final emergency = state.emergency.phase.isEmergencyActive ||
        state.fallStatus == FallStatus.awaitingConfirmation ||
        state.latestPacket != null;
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
                  Text(l10n.appTitle),
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(
            padding: const EdgeInsets.all(AarogyaSpacing.page),
            children: [
              if (emergency)
                StatusPanel(
                  title: l10n.situationEmergency,
                  body: state.fallStatus != FallStatus.none
                      ? l10n.possibleFallDetected
                      : state.emergency.phase.index >=
                            EmergencyPhase.disasterAlert.index
                      ? l10n.floodWarningIssued
                      : phaseLabel(l10n, state.emergency.phase),
                  icon: Icons.emergency_outlined,
                  level: RiskLevel.high,
                )
              else
                StatusPanel(
                  title: l10n.situationNormal,
                  body: phaseLabel(l10n, state.emergency.phase),
                  icon: Icons.monitor_heart_outlined,
                  level: RiskLevel.low,
                ),
              const SizedBox(height: AarogyaSpacing.md),
              const AskAssistantButton(filled: true),
              const SizedBox(height: AarogyaSpacing.sm),
              OutlinedButton(
                onPressed: () => context.go(AppPaths.health),
                child: Text(l10n.openHealth),
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              OutlinedButton(
                onPressed: () => context.go(AppPaths.demo),
                child: Text(l10n.continueDemonstration),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.yourHealth),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MetricRow(
                      label: l10n.heartRateNowUsual,
                      value: nowVersusUsual(
                        l10n,
                        state.currentSample?.heartRateBpm ??
                            state.risk?.comparison?.currentHeartRate,
                        state.baseline?.restingHeartRate?.median ??
                            state.risk?.comparison?.usualHeartRate,
                        l10n.bpmUnit,
                      ),
                      icon: Icons.favorite_border,
                    ),
                    MetricRow(
                      label: l10n.spo2NowUsual,
                      value: nowVersusUsual(
                        l10n,
                        state.currentSample?.spo2Percent ??
                            state.risk?.comparison?.currentSpo2,
                        state.baseline?.spo2?.median ??
                            state.risk?.comparison?.usualSpo2,
                        l10n.percentUnit,
                      ),
                      icon: Icons.air,
                    ),
                    MetricRow(
                      label: l10n.connectivity,
                      value: connectivityLabel(l10n, state.connectivity),
                      icon: state.connectivity == ConnectivityStatus.online
                          ? Icons.wifi
                          : Icons.wifi_off,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
