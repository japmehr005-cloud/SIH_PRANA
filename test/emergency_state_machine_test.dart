import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/result.dart';
import 'package:aarogya/domain/emergency/disaster_activation_source.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_command.dart';
import 'package:aarogya/domain/emergency/emergency_failure.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ControllableClock clock;
  late EmergencyStateMachine machine;

  setUp(() {
    clock = ControllableClock();
    machine = EmergencyStateMachine(clock: clock);
  });

  test('starts in NORMAL', () {
    expect(machine.snapshot.phase, EmergencyPhase.normal);
  });

  test('follows the valid emergency path', () {
    expect(
      machine
          .apply(
            const ActivateDisaster(
              disasterType: DisasterType.flood,
              source: DisasterActivationSource.officialWarning,
            ),
          )
          .isSuccess,
      isTrue,
    );
    expect(machine.snapshot.phase, EmergencyPhase.disasterAlert);

    expect(machine.apply(const ConfirmDisaster()).isSuccess, isTrue);
    expect(machine.snapshot.phase, EmergencyPhase.disasterActive);

    expect(machine.apply(const EnterSurvival()).isSuccess, isTrue);
    expect(machine.snapshot.phase, EmergencyPhase.survival);

    expect(
      machine.apply(const RecordEmergencyEvent(eventId: 'evt-1')).isSuccess,
      isTrue,
    );
    expect(machine.snapshot.phase, EmergencyPhase.emergencyEvent);
    expect(machine.snapshot.lastEventId, 'evt-1');

    expect(machine.apply(const ResolveEmergency()).isSuccess, isTrue);
    expect(machine.snapshot.phase, EmergencyPhase.resolved);

    expect(machine.apply(const ResetToNormal()).isSuccess, isTrue);
    expect(machine.snapshot.phase, EmergencyPhase.normal);
  });

  test('rejects invalid transitions', () {
    final result = machine.apply(const EnterSurvival());
    expect(result, isA<Failure<dynamic>>());
    expect((result as Failure).error, EmergencyFailure.invalidTransition);
  });

  test('does not jump from NORMAL to EMERGENCY_EVENT', () {
    final result = machine.apply(const RecordEmergencyEvent(eventId: 'evt-x'));
    expect(result.isFailure, isTrue);
    expect(machine.snapshot.phase, EmergencyPhase.normal);
  });

  test('hydrate restores persisted emergency state', () {
    machine.apply(
      const ActivateDisaster(
        disasterType: DisasterType.flood,
        source: DisasterActivationSource.officialWarning,
      ),
    );
    final stored = machine.snapshot;
    final restored = EmergencyStateMachine(clock: clock);
    restored.hydrate(stored);
    expect(restored.snapshot.phase, EmergencyPhase.disasterAlert);
    expect(restored.snapshot.disasterType, DisasterType.flood);
  });
}
