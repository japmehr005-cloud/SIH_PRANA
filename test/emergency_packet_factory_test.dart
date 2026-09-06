import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/health_comparison.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/emergency/domain/emergency_packet_factory.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

void main() {
  test('packet carries inferred health state and supporting comparison', () {
    final now = DateTime.utc(2026, 9, 6, 14, 8);
    final current = sample(at: now, hr: 116, spo2: 93);
    final factory = EmergencyPacketFactory(
      ids: SequentialIdGenerator(),
      clock: ControllableClock(now),
    );
    final packet = factory.create(
      eventType: 'physiological_deterioration',
      risk: RiskAssessment(
        level: RiskLevel.critical,
        score: 82,
        reasons: const [],
        timestamp: now,
        modelVersion: 'physio-context-v1',
        contextLabel: 'elevated_load',
        contextConfidence: 0.7,
        usedTrainedModel: true,
        rulesScore: 70,
        modelContribution: 12,
        comparison: HealthComparison(
          currentHeartRate: 116,
          usualHeartRate: 67,
          currentSpo2: 93,
          usualSpo2: 98,
          windowHeartRateMean: 110,
          rulesScore: 70,
          modelContribution: 12,
          sensorSourceId: 'csv-replay',
          sensorSourceKind: SensorSourceKind.simulation,
        ),
      ),
      fallStatus: FallStatus.none,
      sample: current,
      connectivity: ConnectivityStatus.offline,
    );

    expect(packet.contextLabel, 'elevated_load');
    expect(packet.contextConfidence, 0.7);
    expect(packet.baselineHeartRate, 67);
    expect(packet.baselineSpo2, 98);
    expect(packet.windowHeartRateMean, 110);
    expect(packet.rulesScore, 70);
    expect(packet.modelContribution, 12);
    expect(packet.sensorSourceKind, 'simulation');
    expect(packet.fallDetectionMode, 'simulated-sequence');
    expect(packet.modelVersion, 'physio-context-v1');
    expect(packet.originDeviceId, 'local-device');
    expect(packet.ownerUserId, '');
  });

  test('packet uses the persisted origin device id', () {
    final now = DateTime.utc(2026, 9, 6, 14, 8);
    final factory = EmergencyPacketFactory(
      ids: SequentialIdGenerator(),
      clock: ControllableClock(now),
      originDeviceId: 'device-alpha',
      ownerUserId: 'user-a',
    );
    final packet = factory.create(
      eventType: 'possible_fall',
      risk: RiskAssessment(
        level: RiskLevel.high,
        score: 70,
        reasons: const [],
        timestamp: now,
        modelVersion: 'physio-context-v1',
      ),
      fallStatus: FallStatus.possible,
      sample: sample(at: now, hr: 90, spo2: 96),
      connectivity: ConnectivityStatus.offline,
    );
    expect(packet.originDeviceId, 'device-alpha');
    expect(packet.ownerUserId, 'user-a');
  });
}
