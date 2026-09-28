import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/prana_chrome.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/features/assistant/presentation/ask_assistant_button.dart';
import 'package:aarogya/features/health/presentation/demonstration_condition_chips.dart';
import 'package:aarogya/features/health/presentation/health_charts.dart';
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
    final account = ref.watch(dependenciesProvider).accounts.current;
    final name = account?.displayName ?? account?.email ?? l10n.appTitle;
    final emergency =
        state.emergency.phase.isEmergencyActive ||
        state.fallStatus == FallStatus.awaitingConfirmation ||
        state.latestPacket != null;
    final sample = state.currentSample;
    final hrValues = [
      for (final item in state.recentSamples)
        if (item.heartRateBpm != null) item.heartRateBpm!,
    ];
    final spo2Values = [
      for (final item in state.recentSamples)
        if (item.spo2Percent != null) item.spo2Percent!,
    ];
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
                    l10n.greetingNamed(name),
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
          constraints: const BoxConstraints(maxWidth: 1080),
          child: ListView(
            padding: const EdgeInsets.all(AarogyaSpacing.page),
            children: [
              PranaStatus(
                text: emergency
                    ? l10n.situationEmergency
                    : l10n.situationNormal,
                color: emergency ? AarogyaColors.danger : AarogyaColors.accent,
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              Text(
                emergency
                    ? (state.fallStatus != FallStatus.none
                          ? l10n.possibleFallDetected
                          : state.emergency.phase.index >=
                                EmergencyPhase.disasterAlert.index
                          ? l10n.floodWarningIssued
                          : phaseLabel(l10n, state.emergency.phase))
                    : phaseLabel(l10n, state.emergency.phase),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 700;
                  final cards = [
                    PranaMetricCard(
                      title: l10n.heartRate,
                      value: _num(sample?.heartRateBpm, l10n),
                      unit: l10n.bpmUnit,
                      status: _rangeStatus(
                        l10n,
                        sample?.heartRateBpm,
                        state.baseline?.restingHeartRate,
                      ),
                      icon: Icons.favorite_border,
                      accent: AarogyaColors.danger,
                      chart: SampleSparkline(
                        values: hrValues,
                        color: AarogyaColors.danger,
                      ),
                    ),
                    PranaMetricCard(
                      title: l10n.bloodOxygen,
                      value: _num(sample?.spo2Percent, l10n),
                      unit: l10n.percentUnit,
                      status: _rangeStatus(
                        l10n,
                        sample?.spo2Percent,
                        state.baseline?.spo2,
                      ),
                      icon: Icons.air,
                      accent: AarogyaColors.blue,
                      chart: SampleSparkline(
                        values: spo2Values,
                        color: AarogyaColors.blue,
                      ),
                    ),
                    PranaMetricCard(
                      title: l10n.temperature,
                      value: _num(sample?.temperatureC, l10n),
                      unit: l10n.celsiusUnit,
                      status: _rangeStatus(
                        l10n,
                        sample?.temperatureC,
                        state.baseline?.temperature,
                      ),
                      icon: Icons.thermostat,
                      accent: AarogyaColors.warning,
                    ),
                    PranaMetricCard(
                      title: l10n.activity,
                      value: movementLabel(l10n, sample?.movement),
                      unit: '',
                      status: connectivityLabel(l10n, state.connectivity),
                      icon: Icons.directions_walk,
                      accent: AarogyaColors.primary,
                    ),
                  ];
                  if (!wide) {
                    return Column(
                      children: [
                        for (final card in cards) ...[
                          card,
                          const SizedBox(height: AarogyaSpacing.md),
                        ],
                      ],
                    );
                  }
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AarogyaSpacing.md,
                    crossAxisSpacing: AarogyaSpacing.md,
                    childAspectRatio: 1.35,
                    children: cards,
                  );
                },
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.heartRateTrend),
              InfoCard(
                child: HeartRateTrendChart(samples: state.recentSamples),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.activityMix),
              InfoCard(child: MovementMixChart(samples: state.recentSamples)),
              const SizedBox(height: AarogyaSpacing.lg),
              DemonstrationConditionChips(state: state),
            ],
          ),
        ),
      ),
    );
  }

  String _num(double? value, AppLocalizations l10n) {
    return value == null ? l10n.unavailable : value.toStringAsFixed(0);
  }

  String _rangeStatus(
    AppLocalizations l10n,
    double? current,
    MetricRange? range,
  ) {
    if (range == null) {
      return l10n.noBaselineYet;
    }
    if (current == null) {
      return l10n.usualRange(
        range.low.toStringAsFixed(0),
        range.high.toStringAsFixed(0),
      );
    }
    return range.contains(current) ? l10n.withinUsual : l10n.differsFromUsual;
  }
}
