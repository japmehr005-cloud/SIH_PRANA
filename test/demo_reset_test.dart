import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

void main() {
  test(
    'demo reset returns the session to Normal without leftover packets',
    () async {
      final clock = ControllableClock();
      final deps = createInMemoryDependencies(
        clock: clock,
        ids: SequentialIdGenerator(),
      );
      final runtime = deps.runtime;
      await runtime.start();

      for (final item in restingSeries(start: clock.now())) {
        await runtime.ingest(item);
      }
      await runtime.activateOfficialFlood();
      await runtime.confirmDisaster();
      await runtime.enterSurvival();
      expect(runtime.state.emergency.phase, EmergencyPhase.survival);

      await runtime.resetDemo();

      expect(runtime.state.emergency.phase, EmergencyPhase.normal);
      expect(runtime.state.latestPacket, isNull);
      expect(runtime.state.baseline, isNull);
      expect(runtime.state.currentSample, isNull);
      expect(await runtime.emergency.allPackets(), isEmpty);
    },
  );
}
