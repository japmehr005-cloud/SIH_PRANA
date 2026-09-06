import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/demo/domain/demo_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 6);

  SaferLocationGuidance guidance() {
    return SaferLocationGuidance(
      current: DeviceLocation(
        latitude: 27.717,
        longitude: 85.324,
        capturedAt: now,
        source: LocationSource.demonstration,
      ),
      place: const SaferPlace(
        id: 'tudikhel',
        label: 'Tudikhel / Ratna Park',
        location: GeoPoint(latitude: 27.7015, longitude: 85.3160),
      ),
      distanceMeters: 1895,
      bearingDegrees: 225,
      insideHazard: true,
      hazardLabel: 'Demonstration flood area',
      sourceNote: 'Demonstration',
      isDemonstrationDataset: true,
      catalogId: 'kathmandu',
      recommendationReasons: const [
        SaferLocationReason.outsideHazard,
        SaferLocationReason.openSpace,
      ],
    );
  }

  AppSessionState session({
    EmergencyPhase phase = EmergencyPhase.normal,
    ConnectivityStatus connectivity = ConnectivityStatus.online,
    bool baselineReady = false,
    FallStatus fallStatus = FallStatus.none,
    EmergencyPacket? packet,
    SaferLocationGuidance? safer,
  }) {
    return AppSessionState(
      emergency: EmergencySnapshot(phase: phase, updatedAt: now),
      connectivity: connectivity,
      ready: true,
      baseline: baselineReady
          ? PersonalBaseline(
              version: 'test',
              sampleCount: 12,
              computedAt: now,
              restingHeartRate: const MetricRange(
                low: 60,
                high: 72,
                median: 66,
              ),
            )
          : null,
      fallStatus: fallStatus,
      latestPacket: packet,
      guidance: safer,
    );
  }

  EmergencyPacket packet(PacketState state) {
    return EmergencyPacket(
      eventId: 'evt-1',
      timestamp: now,
      eventType: 'possible_fall',
      riskLevel: RiskLevel.high,
      fallStatus: FallStatus.criticalUnconfirmed,
      state: state,
      connectivityAtCreation: ConnectivityStatus.offline,
    );
  }

  test('demo progress follows the six user beats', () {
    expect(DemoProgress.stageCount, 6);
    expect(DemoProgress.completedDomainStages(session()), 0);
    expect(
      DemoProgress.completedDomainStages(session(baselineReady: true)),
      1,
    );
    expect(
      DemoProgress.completedDomainStages(
        session(baselineReady: true, phase: EmergencyPhase.disasterActive),
      ),
      2,
    );
    expect(
      DemoProgress.completedDomainStages(
        session(
          baselineReady: true,
          phase: EmergencyPhase.disasterActive,
          safer: guidance(),
        ),
      ),
      3,
    );
    expect(
      DemoProgress.completedDomainStages(
        session(
          baselineReady: true,
          phase: EmergencyPhase.survival,
          safer: guidance(),
          fallStatus: FallStatus.awaitingConfirmation,
        ),
      ),
      3,
    );
    expect(
      DemoProgress.isComplete(
        4,
        session(
          phase: EmergencyPhase.survival,
          safer: guidance(),
          fallStatus: FallStatus.awaitingConfirmation,
        ),
        rescueOpened: false,
      ),
      isFalse,
    );
    expect(
      DemoProgress.completedDomainStages(
        session(
          phase: EmergencyPhase.emergencyEvent,
          packet: packet(PacketState.stored),
          connectivity: ConnectivityStatus.limited,
        ),
      ),
      4,
    );
    expect(
      DemoProgress.completedDomainStages(
        session(
          phase: EmergencyPhase.emergencyEvent,
          packet: packet(PacketState.sent),
        ),
      ),
      5,
    );
    expect(
      DemoProgress.isComplete(
        6,
        session(packet: packet(PacketState.deliveryConfirmed)),
        rescueOpened: false,
      ),
      isFalse,
    );
    expect(
      DemoProgress.isComplete(
        6,
        session(packet: packet(PacketState.deliveryConfirmed)),
        rescueOpened: true,
      ),
      isTrue,
    );
  });
}
