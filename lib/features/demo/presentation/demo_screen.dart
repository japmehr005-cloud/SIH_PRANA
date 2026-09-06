import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/aarogya_runtime.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/mode_chip.dart';
import 'package:aarogya/app/widgets/stage_strip.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/domain/location/location_preference.dart';
import 'package:aarogya/features/demo/application/demo_controller.dart';
import 'package:aarogya/features/demo/domain/demo_progress.dart';
import 'package:aarogya/features/health/presentation/home_screen.dart';
import 'package:aarogya/features/rescue/presentation/rescue_dashboard_screen.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoScreen extends ConsumerStatefulWidget {
  const DemoScreen({super.key});

  @override
  ConsumerState<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends ConsumerState<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    final presenter = ref.watch(demoControllerProvider);

    return Scaffold(
      body: session.when(
        loading: () => Center(child: Text(l10n.loading)),
        error: (_, _) => Padding(
          padding: const EdgeInsets.all(AarogyaSpacing.page),
          child: Center(child: Text(l10n.errorContinue)),
        ),
        data: (state) {
          final focused = presenter.focusedStage.clamp(
            1,
            DemoProgress.stageCount,
          );
          return Column(
            children: [
              _DemoHeader(
                state: state,
                stage: focused,
                onReset: presenter.busy ? null : _reset,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AarogyaSpacing.page,
                  AarogyaSpacing.md,
                  AarogyaSpacing.page,
                  AarogyaSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StageStrip(
                      labels: [
                        l10n.stageShort1,
                        l10n.stageShort2,
                        l10n.stageShort3,
                        l10n.stageShort4,
                        l10n.stageShort5,
                        l10n.stageShort6,
                      ],
                      focusedStage: focused,
                      completedThrough: presenter.rescueOpened
                          ? DemoProgress.stageCount
                          : DemoProgress.completedDomainStages(state),
                    ),
                    const SizedBox(height: AarogyaSpacing.md),
                    _BeatHero(stage: focused),
                  ],
                ),
              ),
              Expanded(
                child: focused == DemoProgress.stageCount
                    ? const RescueDashboardScreen(embedded: true)
                    : const HomeScreen(embedded: true),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AarogyaSpacing.page,
                      0,
                      AarogyaSpacing.page,
                      AarogyaSpacing.page,
                    ),
                    child: _DemoActions(
                      stage: focused,
                      busy: presenter.busy,
                      onNext: presenter.busy ? null : () => _next(state),
                      onReset: presenter.busy ? null : _reset,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _reset() async {
    await ref
        .read(demoControllerProvider.notifier)
        .reset(ref.read(dependenciesProvider).runtime);
  }

  Future<void> _next(AppSessionState state) async {
    final controller = ref.read(demoControllerProvider.notifier);
    final presenter = ref.read(demoControllerProvider);
    final stage = presenter.focusedStage;
    final complete = DemoProgress.isComplete(
      stage,
      state,
      rescueOpened: presenter.rescueOpened,
    );

    controller.setBusy(true);
    try {
      if (!complete) {
        await _runStage(stage);
        return;
      }
      if (stage < DemoProgress.stageCount) {
        controller.advanceFocus();
        final nextStage = stage + 1;
        if (nextStage <= DemoProgress.stageCount) {
          await _runStage(nextStage);
        }
        return;
      }
      await _runStage(stage);
    } finally {
      controller.setBusy(false);
    }
  }

  Future<void> _runStage(int stage) async {
    final runtime = ref.read(dependenciesProvider).runtime;
    switch (stage) {
      case 1:
        await _applyCondition(runtime, DemonstrationCondition.resting);
      case 2:
        await runtime.activateOfficialFlood();
        await runtime.confirmDisaster();
      case 3:
        final region = runtime.state.selectedRegionId;
        if (region != DemonstrationRegionIds.delhi) {
          await runtime.selectDemonstrationRegion(
            DemonstrationRegionIds.kathmandu,
          );
        }
      case 4:
        await _applyCondition(runtime, DemonstrationCondition.fallImpact);
        await runtime.enterSurvival();
        await runtime.setConnectivity(ConnectivityStatus.limited);
      case 5:
        await runtime.setConnectivity(ConnectivityStatus.online);
      case 6:
        ref.read(demoControllerProvider.notifier).markRescueOpened();
    }
  }

  Future<void> _applyCondition(
    AarogyaRuntime runtime,
    DemonstrationCondition condition,
  ) async {
    final bundle = DefaultAssetBundle.of(context);
    final csv = await bundle.loadString(condition.assetPath);
    final restingCsv = condition == DemonstrationCondition.resting
        ? null
        : await bundle.loadString(DemonstrationCondition.resting.assetPath);
    await runtime.applyDemonstrationCondition(
      condition,
      csv: csv,
      restingCsv: restingCsv,
    );
  }
}

class _DemoHeader extends ConsumerWidget {
  const _DemoHeader({
    required this.state,
    required this.stage,
    required this.onReset,
  });

  final AppSessionState state;
  final int stage;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeControllerProvider);
    return Material(
      color: AarogyaColors.surface,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AarogyaColors.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AarogyaSpacing.page,
            AarogyaSpacing.md,
            AarogyaSpacing.page,
            AarogyaSpacing.md,
          ),
          child: Wrap(
            spacing: AarogyaSpacing.md,
            runSpacing: AarogyaSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      l10n.productTagline,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AarogyaColors.textSecondary),
                    ),
                  ],
                ),
              ),
              ModeChip(phase: state.emergency.phase),
              Text(
                connectivityLabel(l10n, state.connectivity),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                l10n.demoStageProgress(stage, DemoProgress.stageCount),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                l10n.simulationBadge,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AarogyaColors.warning),
              ),
              TextButton(
                onPressed: () {
                  unawaited(
                    ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(
                          Locale(locale.languageCode == 'en' ? 'hi' : 'en'),
                        ),
                  );
                },
                child: Text(
                  locale.languageCode == 'en' ? l10n.hindi : l10n.english,
                ),
              ),
              TextButton(onPressed: onReset, child: Text(l10n.demoReset)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeatHero extends StatelessWidget {
  const _BeatHero({required this.stage});

  final int stage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (stage) {
      1 => l10n.demoStage1Hero,
      2 => l10n.demoStage2Hero,
      3 => l10n.demoStage3Hero,
      4 => l10n.demoStage4Hero,
      5 => l10n.demoStage5Hero,
      _ => l10n.demoStage6Hero,
    };
    final body = switch (stage) {
      1 => l10n.demoStage1HeroBody,
      2 => l10n.demoStage2HeroBody,
      3 => l10n.demoStage3HeroBody,
      4 => l10n.demoStage4HeroBody,
      5 => l10n.demoStage5HeroBody,
      _ => l10n.demoStage6HeroBody,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AarogyaSpacing.xs),
        Text(body, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _DemoActions extends StatelessWidget {
  const _DemoActions({
    required this.stage,
    required this.busy,
    required this.onNext,
    required this.onReset,
  });

  final int stage;
  final bool busy;
  final VoidCallback? onNext;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: onNext,
            child: busy
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    stage == DemoProgress.stageCount
                        ? l10n.emergencyResponse
                        : l10n.demoNextStage,
                  ),
          ),
        ),
        const SizedBox(width: AarogyaSpacing.md),
        Expanded(
          child: OutlinedButton(
            onPressed: onReset,
            child: Text(l10n.demoReset),
          ),
        ),
      ],
    );
  }
}
