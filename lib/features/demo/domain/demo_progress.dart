import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';

abstract final class DemoProgress {
  static const int stageCount = 6;

  static int completedDomainStages(AppSessionState state) {
    if (state.latestPacket != null && state.connectivity.canTransmit) {
      return 5;
    }
    if (state.latestPacket != null) {
      return 4;
    }
    if (state.emergency.phase.index >= EmergencyPhase.disasterActive.index &&
        state.guidance != null) {
      return 3;
    }
    if (state.emergency.phase.index >= EmergencyPhase.disasterActive.index) {
      return 2;
    }
    if (state.baseline?.isEstablished == true) {
      return 1;
    }
    return 0;
  }

  static bool isComplete(
    int stage,
    AppSessionState state, {
    required bool rescueOpened,
  }) {
    if (stage >= stageCount) {
      return rescueOpened;
    }
    if (stage == 4 &&
        state.latestPacket == null &&
        state.fallStatus == FallStatus.awaitingConfirmation) {
      return false;
    }
    return completedDomainStages(state) >= stage;
  }
}
