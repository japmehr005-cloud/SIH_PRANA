import 'dart:async';

import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/domain/assistant/assistant_turn.dart';
import 'package:aarogya/features/assistant/data/assistant_conversation_store.dart';
import 'package:aarogya/features/assistant/domain/assistant_composer.dart';
import 'package:aarogya/features/assistant/domain/assistant_intent_router.dart';
import 'package:aarogya/features/assistant/domain/assistant_situation_compiler.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AssistantConversationState {
  const AssistantConversationState({
    required this.userId,
    required this.turns,
    required this.ready,
  });

  final String userId;
  final List<AssistantTurn> turns;
  final bool ready;

  AssistantConversationState copyWith({
    String? userId,
    List<AssistantTurn>? turns,
    bool? ready,
  }) {
    return AssistantConversationState(
      userId: userId ?? this.userId,
      turns: turns ?? this.turns,
      ready: ready ?? this.ready,
    );
  }
}

final assistantConversationProvider =
    NotifierProvider<
      AssistantConversationController,
      AssistantConversationState
    >(AssistantConversationController.new);

class AssistantConversationController
    extends Notifier<AssistantConversationState> {
  final AssistantConversationStore _store = AssistantConversationStore();

  @override
  AssistantConversationState build() {
    final accounts = ref.watch(dependenciesProvider).accounts;
    if (accounts is Listenable) {
      final listenable = accounts as Listenable;
      void onAccountChanged() {
        final next = _currentUserId();
        if (next != state.userId) {
          unawaited(hydrate(next));
        }
      }

      listenable.addListener(onAccountChanged);
      ref.onDispose(() => listenable.removeListener(onAccountChanged));
    }
    final userId = _currentUserId();
    Future<void>.microtask(() => hydrate(userId));
    return AssistantConversationState(
      userId: userId,
      turns: const [],
      ready: false,
    );
  }

  String _currentUserId() {
    return ref.read(dependenciesProvider).accounts.current?.userId ?? 'local';
  }

  Future<void> hydrate([String? userId]) async {
    final scope = userId ?? _currentUserId();
    if (state.userId != scope) {
      state = AssistantConversationState(
        userId: scope,
        turns: const [],
        ready: false,
      );
    }
    var turns = const <AssistantTurn>[];
    try {
      turns = await _store.load(scope);
    } catch (_) {
      turns = const [];
    }
    if (!ref.mounted) {
      return;
    }
    state = AssistantConversationState(
      userId: scope,
      turns: turns,
      ready: true,
    );
  }

  Future<void> ask({
    required String raw,
    required AppSessionState session,
    required AppLocalizations l10n,
  }) async {
    final question = raw.trim();
    if (question.isEmpty) {
      return;
    }
    final userId = _currentUserId();
    if (!state.ready || userId != state.userId) {
      await hydrate(userId);
    }
    final match = AssistantIntentRouter.route(question, l10n: l10n);
    final reply = AssistantComposer.compose(
      intent: match.intent,
      situation: AssistantSituationCompiler.compile(session),
      l10n: l10n,
      unrecognized: match.unrecognized,
    );
    final turn = AssistantTurn(
      question: question,
      headline: reply.headline,
      lines: reply.lines,
      askedAt: DateTime.now().toUtc(),
    );
    final next = [...state.turns, turn];
    state = state.copyWith(userId: userId, turns: next, ready: true);
    try {
      await _store.save(userId, next);
    } catch (_) {}
  }
}
