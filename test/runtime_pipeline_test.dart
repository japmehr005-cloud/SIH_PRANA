import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

void main() {
  test(
    'sensor replay goes through inference before creating an emergency packet',
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
      expect(runtime.state.baseline?.isEstablished, isTrue);

      await runtime.activateOfficialFlood();
      await runtime.confirmDisaster();
      await runtime.enterSurvival();
      expect(runtime.state.emergency.phase, EmergencyPhase.survival);
      expect(runtime.state.emergency.disasterType, DisasterType.flood);

      final start = clock.now();
      await runtime.ingest(
        sample(
          at: start,
          hr: 80,
          spo2: 97,
          accel: 1.4,
          movement: MovementState.low,
        ),
      );
      await runtime.ingest(
        sample(
          at: start.add(const Duration(milliseconds: 200)),
          hr: 84,
          spo2: 97,
          accel: 28.4,
          movement: MovementState.irregular,
        ),
      );
      await runtime.ingest(
        sample(
          at: start.add(const Duration(milliseconds: 400)),
          hr: 86,
          spo2: 96,
          accel: 6.2,
          orientation: 0.9,
          movement: MovementState.none,
        ),
      );
      await runtime.ingest(
        sample(
          at: start.add(const Duration(milliseconds: 600)),
          hr: 86,
          spo2: 96,
          accel: 1.0,
          movement: MovementState.none,
        ),
      );
      await runtime.ingest(
        sample(
          at: start.add(const Duration(milliseconds: 800)),
          hr: 86,
          spo2: 96,
          accel: 0.9,
          movement: MovementState.none,
        ),
      );

      expect(runtime.state.fallStatus, FallStatus.awaitingConfirmation);
      expect(runtime.state.latestPacket, isNull);

      clock.advance(const Duration(seconds: 21));
      await runtime.escalateUnconfirmedFall();

      expect(runtime.state.emergency.phase, EmergencyPhase.emergencyEvent);
      expect(runtime.state.latestPacket, isNotNull);
      expect(runtime.state.latestPacket!.state, isNot(PacketState.created));
      expect(runtime.state.engineVersion, isNotEmpty);
      expect(
        runtime.state.latestPacket!.fallDetectionMode,
        'simulated-sequence',
      );
      expect(runtime.state.latestPacket!.sensorSourceKind, 'simulation');
      expect(runtime.state.recentSamples, isNotEmpty);

      await runtime.dispose();
    },
  );

  test('I am safe records a cancelled fall check and creates no packet', () async {
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
    final start = clock.now();
    await runtime.ingest(
      sample(
        at: start,
        hr: 80,
        spo2: 97,
        accel: 1.4,
        movement: MovementState.low,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        hr: 84,
        spo2: 97,
        accel: 28.4,
        movement: MovementState.irregular,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        hr: 86,
        spo2: 96,
        accel: 6.2,
        orientation: 0.9,
        movement: MovementState.none,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        hr: 86,
        spo2: 96,
        accel: 1.0,
        movement: MovementState.none,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 800)),
        hr: 86,
        spo2: 96,
        accel: 0.9,
        movement: MovementState.none,
      ),
    );
    expect(runtime.state.fallStatus, FallStatus.awaitingConfirmation);
    await runtime.userIsOk();
    expect(runtime.state.fallStatus, FallStatus.none);
    expect(runtime.state.fallCheckCancelled, isTrue);
    expect(runtime.state.latestPacket, isNull);
    expect(runtime.state.emergency.phase, EmergencyPhase.survival);
    expect(await runtime.emergency.allPackets(), isEmpty);
    await runtime.dispose();
  });

  test('I need help creates a possible_fall packet with location', () async {
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
    final start = clock.now();
    await runtime.ingest(
      sample(
        at: start,
        hr: 80,
        spo2: 97,
        accel: 1.4,
        movement: MovementState.low,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        hr: 84,
        spo2: 97,
        accel: 28.4,
        movement: MovementState.irregular,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        hr: 86,
        spo2: 96,
        accel: 6.2,
        orientation: 0.9,
        movement: MovementState.none,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        hr: 86,
        spo2: 96,
        accel: 1.0,
        movement: MovementState.none,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 800)),
        hr: 86,
        spo2: 96,
        accel: 0.9,
        movement: MovementState.none,
      ),
    );
    expect(runtime.state.fallStatus, FallStatus.awaitingConfirmation);
    await runtime.userNeedsHelp();
    expect(runtime.state.latestPacket, isNotNull);
    expect(runtime.state.latestPacket!.eventType, 'possible_fall');
    expect(runtime.state.latestPacket!.locationAvailable, isTrue);
    expect(runtime.state.latestPacket!.latitude, isNotNull);
    expect(runtime.state.latestPacket!.longitude, isNotNull);
    await runtime.dispose();
  });
}
