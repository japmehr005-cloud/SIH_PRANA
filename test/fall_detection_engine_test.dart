import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/features/edge_ai/domain/fall_detection_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

void main() {
  const engine = FallDetectionEngine();
  final start = DateTime.utc(2026, 9, 6, 14);

  test('sequence detector stays labeled simulated-sequence', () {
    expect(engine.mode, 'simulated-sequence');
  });

  test('detects a spike-impact-orientation-inactivity sequence', () {
    final window = [
      sample(at: start, accel: 1.4, movement: MovementState.low),
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        accel: 28.4,
        movement: MovementState.irregular,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        accel: 6.2,
        orientation: 0.9,
        movement: MovementState.none,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        accel: 1.1,
        movement: MovementState.none,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 800)),
        accel: 1.0,
        movement: MovementState.none,
      ),
      sample(
        at: start.add(const Duration(seconds: 1)),
        accel: 0.9,
        movement: MovementState.none,
      ),
    ];
    expect(engine.detect(window), FallStatus.possible);
  });

  test('does not treat running as a fall', () {
    final window = [
      sample(at: start, accel: 26, movement: MovementState.high),
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        accel: 12,
        movement: MovementState.high,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        accel: 11,
        movement: MovementState.high,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        accel: 10,
        movement: MovementState.high,
      ),
    ];
    expect(engine.detect(window), FallStatus.none);
  });

  test('does not treat a quick sit as a fall', () {
    final window = [
      sample(at: start, accel: 8, movement: MovementState.normal),
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        accel: 6,
        movement: MovementState.low,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        accel: 1.2,
        movement: MovementState.low,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        accel: 1.1,
        movement: MovementState.low,
      ),
    ];
    expect(engine.detect(window), FallStatus.none);
  });

  test('does not treat a phone drop with continued handling as a fall', () {
    final window = [
      sample(at: start, accel: 30, movement: MovementState.irregular),
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        accel: 4,
        movement: MovementState.high,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        accel: 3,
        movement: MovementState.normal,
      ),
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        accel: 2,
        movement: MovementState.normal,
      ),
    ];
    expect(engine.detect(window), FallStatus.none);
  });
}
