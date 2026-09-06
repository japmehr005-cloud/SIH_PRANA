import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/result.dart';
import 'package:aarogya/domain/emergency/emergency_command.dart';
import 'package:aarogya/domain/emergency/emergency_failure.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';

final class EmergencyStateMachine {
  EmergencyStateMachine({required Clock clock, EmergencySnapshot? initial})
    : _clock = clock,
      _snapshot = initial ?? EmergencySnapshot.normal(clock.now());

  final Clock _clock;
  EmergencySnapshot _snapshot;

  EmergencySnapshot get snapshot => _snapshot;

  void hydrate(EmergencySnapshot snapshot) {
    _snapshot = snapshot;
  }

  Result<EmergencySnapshot> apply(EmergencyCommand command) {
    final next = switch (command) {
      ActivateDisaster() => _activateDisaster(command),
      ConfirmDisaster() => _transition(
        from: {EmergencyPhase.disasterAlert},
        to: EmergencyPhase.disasterActive,
      ),
      EnterSurvival() => _enterSurvival(),
      RecordEmergencyEvent(:final eventId) => _recordEvent(eventId),
      ResolveEmergency() => _resolve(),
      ResetToNormal() => _reset(),
    };

    if (next is Success<EmergencySnapshot>) {
      _snapshot = next.value;
    }
    return next;
  }

  Result<EmergencySnapshot> _activateDisaster(ActivateDisaster command) {
    if (_snapshot.phase != EmergencyPhase.normal &&
        _snapshot.phase != EmergencyPhase.resolved) {
      return const Failure(EmergencyFailure.invalidTransition);
    }
    return Success(
      _snapshot.copyWith(
        phase: EmergencyPhase.disasterAlert,
        disasterType: command.disasterType,
        activationSource: command.source,
        updatedAt: _clock.now(),
        stranded: false,
        clearEvent: true,
      ),
    );
  }

  Result<EmergencySnapshot> _enterSurvival() {
    if (_snapshot.phase != EmergencyPhase.disasterActive &&
        _snapshot.phase != EmergencyPhase.disasterAlert) {
      return const Failure(EmergencyFailure.invalidTransition);
    }
    if (_snapshot.disasterType == null) {
      return const Failure(EmergencyFailure.missingDisasterType);
    }
    return Success(
      _snapshot.copyWith(
        phase: EmergencyPhase.survival,
        updatedAt: _clock.now(),
        stranded: true,
      ),
    );
  }

  Result<EmergencySnapshot> _recordEvent(String eventId) {
    if (_snapshot.phase != EmergencyPhase.survival &&
        _snapshot.phase != EmergencyPhase.emergencyEvent) {
      return const Failure(EmergencyFailure.invalidTransition);
    }
    return Success(
      _snapshot.copyWith(
        phase: EmergencyPhase.emergencyEvent,
        lastEventId: eventId,
        updatedAt: _clock.now(),
        stranded: true,
      ),
    );
  }

  Result<EmergencySnapshot> _resolve() {
    if (_snapshot.phase != EmergencyPhase.emergencyEvent &&
        _snapshot.phase != EmergencyPhase.survival &&
        _snapshot.phase != EmergencyPhase.disasterActive) {
      return const Failure(EmergencyFailure.invalidTransition);
    }
    return Success(
      _snapshot.copyWith(
        phase: EmergencyPhase.resolved,
        updatedAt: _clock.now(),
      ),
    );
  }

  Result<EmergencySnapshot> _reset() {
    if (_snapshot.phase != EmergencyPhase.resolved &&
        _snapshot.phase != EmergencyPhase.normal) {
      return const Failure(EmergencyFailure.invalidTransition);
    }
    return Success(EmergencySnapshot.normal(_clock.now()));
  }

  Result<EmergencySnapshot> _transition({
    required Set<EmergencyPhase> from,
    required EmergencyPhase to,
  }) {
    if (!from.contains(_snapshot.phase)) {
      return const Failure(EmergencyFailure.invalidTransition);
    }
    return Success(_snapshot.copyWith(phase: to, updatedAt: _clock.now()));
  }
}
