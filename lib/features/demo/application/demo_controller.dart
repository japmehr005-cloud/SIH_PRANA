import 'package:aarogya/app/session/aarogya_runtime.dart';
import 'package:aarogya/features/demo/domain/demo_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final demoControllerProvider =
    NotifierProvider<DemoController, DemoPresenterState>(DemoController.new);

final class DemoPresenterState {
  const DemoPresenterState({
    this.focusedStage = 1,
    this.busy = false,
    this.autoPlaying = false,
    this.rescueOpened = false,
  });

  final int focusedStage;
  final bool busy;
  final bool autoPlaying;
  final bool rescueOpened;

  DemoPresenterState copyWith({
    int? focusedStage,
    bool? busy,
    bool? autoPlaying,
    bool? rescueOpened,
  }) {
    return DemoPresenterState(
      focusedStage: focusedStage ?? this.focusedStage,
      busy: busy ?? this.busy,
      autoPlaying: autoPlaying ?? this.autoPlaying,
      rescueOpened: rescueOpened ?? this.rescueOpened,
    );
  }
}

class DemoController extends Notifier<DemoPresenterState> {
  @override
  DemoPresenterState build() => const DemoPresenterState();

  void previous() {
    if (state.busy || state.focusedStage <= 1) {
      return;
    }
    state = state.copyWith(focusedStage: state.focusedStage - 1);
  }

  void advanceFocus() {
    if (state.focusedStage >= DemoProgress.stageCount) {
      return;
    }
    state = state.copyWith(focusedStage: state.focusedStage + 1);
  }

  void markRescueOpened() {
    state = state.copyWith(rescueOpened: true);
  }

  void setBusy(bool busy) {
    state = state.copyWith(busy: busy);
  }

  void setAutoPlaying(bool autoPlaying) {
    state = state.copyWith(autoPlaying: autoPlaying);
  }

  Future<void> reset(AarogyaRuntime runtime) async {
    state = state.copyWith(busy: true, autoPlaying: false);
    await runtime.resetDemo();
    state = const DemoPresenterState();
  }
}
