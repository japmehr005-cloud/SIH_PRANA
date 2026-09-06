import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';

final class EmergencyPacketFactory {
  EmergencyPacketFactory({
    required this.ids,
    required this.clock,
    this.originDeviceId = 'local-device',
    this.ownerUserId = '',
    this.originDisplayName = '',
  });

  final IdGenerator ids;
  final Clock clock;
  String originDeviceId;
  String ownerUserId;
  String originDisplayName;

  EmergencyPacket create({
    required String eventType,
    required RiskAssessment risk,
    required FallStatus fallStatus,
    required SensorSample sample,
    required ConnectivityStatus connectivity,
    DeviceLocation? location,
    String fallDetectionMode = 'simulated-sequence',
  }) {
    final comparison = risk.comparison;
    return EmergencyPacket(
      eventId: ids.next(),
      timestamp: clock.now(),
      eventType: eventType,
      riskLevel: risk.level,
      fallStatus: fallStatus,
      state: PacketState.created,
      connectivityAtCreation: connectivity,
      movement: sample.movement,
      heartRateBpm: sample.heartRateBpm,
      spo2Percent: sample.spo2Percent,
      batteryPercent: sample.batteryPercent,
      latitude: location?.latitude ?? sample.latitude,
      longitude: location?.longitude ?? sample.longitude,
      originDeviceId: originDeviceId,
      ownerUserId: ownerUserId,
      originDisplayName: originDisplayName,
      modelVersion: risk.modelVersion,
      riskScore: risk.score,
      contextLabel: risk.contextLabel,
      contextConfidence: risk.contextConfidence,
      baselineHeartRate: comparison?.usualHeartRate,
      baselineSpo2: comparison?.usualSpo2,
      windowHeartRateMean: comparison?.windowHeartRateMean,
      rulesScore: risk.rulesScore,
      modelContribution: risk.modelContribution,
      sensorSourceId: sample.sourceId,
      sensorSourceKind: sample.sourceKind.name,
      fallDetectionMode: fallDetectionMode,
    );
  }
}
