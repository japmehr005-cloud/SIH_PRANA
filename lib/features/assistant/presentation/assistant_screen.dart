import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/assistant/assistant_turn.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/assistant/application/assistant_conversation_controller.dart';
import 'package:aarogya/features/assistant/domain/assistant_intent_router.dart';
import 'package:aarogya/features/assistant/domain/assistant_situation_compiler.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract final class PranaAssistantKeys {
  static const field = Key('pranaAssistantField');
  static const ask = Key('pranaAssistantAsk');
  static const iAmSafe = Key('pranaAssistantIAmSafe');
  static const iNeedHelp = Key('pranaAssistantINeedHelp');
  static const conversation = Key('pranaAssistantConversation');
}

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  bool _asking = false;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _ask(AppSessionState session, String raw) async {
    final question = raw.trim();
    if (question.isEmpty || _asking) {
      return;
    }
    setState(() => _asking = true);
    try {
      await ref
          .read(assistantConversationProvider.notifier)
          .ask(
            raw: question,
            session: session,
            l10n: AppLocalizations.of(context),
          );
      _controller.clear();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (_scroll.hasClients) {
        await _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _asking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    final conversation = ref.watch(assistantConversationProvider);

    return session.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.pranaAssistant)),
        body: Center(child: Text(l10n.loading)),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.pranaAssistant)),
        body: Center(child: Text(l10n.errorContinue)),
      ),
      data: (state) {
        final situation = AssistantSituationCompiler.compile(state);
        final emergencyFirst =
            situation.phase.isEmergencyActive ||
            situation.fallStatus == FallStatus.awaitingConfirmation ||
            situation.packetPresent;
        final questions = AssistantIntentRouter.suggestedQuestions(l10n);
        final chips = [
          for (final intent in AssistantIntentRouter.chipOrder(
            emergencyFirst: emergencyFirst,
          ))
            ?questions[intent],
        ];
        final status = _statusLabel(l10n, state);
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
                      Text(l10n.pranaAssistant),
                      Text(
                        l10n.assistantHowCanIHelp,
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AarogyaSpacing.page,
                      AarogyaSpacing.page,
                      AarogyaSpacing.page,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.assistantStatusHeading,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AarogyaSpacing.xs),
                              Text(
                                status,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: _statusColor(state),
                                    ),
                              ),
                              const SizedBox(height: AarogyaSpacing.sm),
                              Text(phaseLabel(l10n, state.emergency.phase)),
                              Text(connectivityLabel(l10n, state.connectivity)),
                            ],
                          ),
                        ),
                        const SizedBox(height: AarogyaSpacing.md),
                        InfoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.personalBaseline,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AarogyaSpacing.sm),
                              _BaselineRow(
                                label: l10n.heartRate,
                                usual: state.baseline?.restingHeartRate == null
                                    ? l10n.unavailable
                                    : l10n.usualRange(
                                        state.baseline!.restingHeartRate!.low
                                            .toStringAsFixed(0),
                                        state.baseline!.restingHeartRate!.high
                                            .toStringAsFixed(0),
                                      ),
                                now: state.currentSample?.heartRateBpm == null
                                    ? l10n.unavailable
                                    : '${state.currentSample!.heartRateBpm!.toStringAsFixed(0)} ${l10n.bpmUnit}',
                              ),
                              _BaselineRow(
                                label: l10n.bloodOxygen,
                                usual: state.baseline?.spo2 == null
                                    ? l10n.unavailable
                                    : l10n.usualRange(
                                        state.baseline!.spo2!.low
                                            .toStringAsFixed(0),
                                        state.baseline!.spo2!.high
                                            .toStringAsFixed(0),
                                      ),
                                now: state.currentSample?.spo2Percent == null
                                    ? l10n.unavailable
                                    : '${state.currentSample!.spo2Percent!.toStringAsFixed(0)} ${l10n.percentUnit}',
                              ),
                              if (state.risk != null &&
                                  !state.risk!.insufficientData)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AarogyaSpacing.sm,
                                  ),
                                  child: Text(
                                    '${l10n.comparedWithUsual}: ${riskLabel(l10n, state.visibleRisk)}',
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AarogyaSpacing.md),
                        Wrap(
                          spacing: AarogyaSpacing.sm,
                          runSpacing: AarogyaSpacing.sm,
                          children: [
                            for (final question in chips)
                              ActionChip(
                                label: Text(question),
                                onPressed: () {
                                  unawaited(_ask(state, question));
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state.fallStatus == FallStatus.awaitingConfirmation)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AarogyaSpacing.page,
                        AarogyaSpacing.md,
                        AarogyaSpacing.page,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledButton(
                            key: PranaAssistantKeys.iAmSafe,
                            onPressed: () {
                              unawaited(
                                ref
                                    .read(dependenciesProvider)
                                    .runtime
                                    .userIsOk(),
                              );
                            },
                            child: Text(l10n.iAmOk),
                          ),
                          const SizedBox(height: AarogyaSpacing.sm),
                          OutlinedButton(
                            key: PranaAssistantKeys.iNeedHelp,
                            onPressed: () {
                              unawaited(
                                ref
                                    .read(dependenciesProvider)
                                    .runtime
                                    .userNeedsHelp(),
                              );
                            },
                            child: Text(l10n.iNeedHelp),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView(
                      key: PranaAssistantKeys.conversation,
                      controller: _scroll,
                      padding: const EdgeInsets.all(AarogyaSpacing.page),
                      children: [
                        if (conversation.turns.isEmpty)
                          Text(
                            l10n.assistantHowCanIHelp,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AarogyaColors.textSecondary),
                          ),
                        for (final turn in conversation.turns) ...[
                          _TurnBlock(turn: turn),
                          const SizedBox(height: AarogyaSpacing.md),
                        ],
                      ],
                    ),
                  ),
                  Material(
                    elevation: 2,
                    color: AarogyaColors.surface,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AarogyaSpacing.page,
                        AarogyaSpacing.md,
                        AarogyaSpacing.page,
                        AarogyaSpacing.page,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.askPranaAssistant,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: AarogyaSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  key: PranaAssistantKeys.field,
                                  controller: _controller,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (value) {
                                    unawaited(_ask(state, value));
                                  },
                                  decoration: InputDecoration(
                                    labelText: l10n.assistantAskHint,
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AarogyaSpacing.sm),
                              FilledButton(
                                key: PranaAssistantKeys.ask,
                                onPressed: () {
                                  unawaited(_ask(state, _controller.text));
                                },
                                child: Text(l10n.assistantSend),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _statusLabel(AppLocalizations l10n, AppSessionState state) {
    if (state.emergency.phase.isEmergencyActive ||
        state.fallStatus == FallStatus.awaitingConfirmation ||
        state.latestPacket != null) {
      return l10n.assistantStatusEmergency;
    }
    if (state.risk != null &&
        !state.risk!.insufficientData &&
        state.visibleRisk.rank >= RiskLevel.moderate.rank) {
      return l10n.assistantStatusElevated;
    }
    return l10n.assistantStatusNormal;
  }

  Color _statusColor(AppSessionState state) {
    if (state.emergency.phase.isEmergencyActive ||
        state.fallStatus == FallStatus.awaitingConfirmation ||
        state.latestPacket != null) {
      return AarogyaColors.danger;
    }
    if (state.risk != null &&
        !state.risk!.insufficientData &&
        state.visibleRisk.rank >= RiskLevel.moderate.rank) {
      return AarogyaColors.warning;
    }
    return AarogyaColors.safe;
  }
}

class _BaselineRow extends StatelessWidget {
  const _BaselineRow({
    required this.label,
    required this.usual,
    required this.now,
  });

  final String label;
  final String usual;
  final String now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AarogyaSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Expanded(child: Text('${l10n.baselineTableUsual}: $usual')),
          Expanded(child: Text('${l10n.baselineTableNow}: $now')),
        ],
      ),
    );
  }
}

class _TurnBlock extends StatelessWidget {
  const _TurnBlock({required this.turn});

  final AssistantTurn turn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          turn.question,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AarogyaColors.textSecondary,
          ),
        ),
        const SizedBox(height: AarogyaSpacing.sm),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                turn.headline,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AarogyaColors.textPrimary,
                ),
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              for (final line in turn.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AarogyaSpacing.sm),
                  child: Text(line),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
