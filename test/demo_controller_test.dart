import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/features/demo/application/demo_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'previous is safe and reset returns Normal without leftover packets',
    () async {
      final deps = createInMemoryDependencies();
      await deps.runtime.start();
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(demoControllerProvider.notifier);

      await deps.runtime.activateOfficialFlood();
      expect(deps.runtime.state.emergency.phase, EmergencyPhase.disasterAlert);

      controller.advanceFocus();
      controller.advanceFocus();
      expect(container.read(demoControllerProvider).focusedStage, 3);
      controller.previous();
      expect(container.read(demoControllerProvider).focusedStage, 2);
      expect(deps.runtime.state.emergency.phase, EmergencyPhase.disasterAlert);

      await controller.reset(deps.runtime);
      expect(deps.runtime.state.emergency.phase, EmergencyPhase.normal);
      expect(deps.runtime.state.latestPacket, isNull);
      expect(container.read(demoControllerProvider).focusedStage, 1);
      expect(container.read(demoControllerProvider).rescueOpened, isFalse);
      expect(await deps.runtime.emergency.allPackets(), isEmpty);
    },
  );
}
