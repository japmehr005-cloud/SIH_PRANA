import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/risk/risk_level.dart';

final class EmergencyPacket {
  const EmergencyPacket({
    required this.eventId,
    required this.timestamp,
    required this.eventType,
    required this.riskLevel,
    required this.fallStatus,
    required this.state,
    required this.connectivityAtCreation,
    this.movement,
    this.heartRateBpm,
    this.spo2Percent,
    this.batteryPercent,
    this.latitude,
    this.longitude,
    this.originDeviceId = 'local-device',
    this.hopCount = 0,
    this.expiresAt,
    this.modelVersion,
    this.riskScore,
    this.contextLabel,
    this.contextConfidence,
    this.baselineHeartRate,
    this.baselineSpo2,
    this.windowHeartRateMean,
    this.rulesScore,
    this.modelContribution,
    this.sensorSourceId,
    this.sensorSourceKind,
    this.fallDetectionMode = 'simulated-sequence',
    this.ownerUserId = '',
    this.originDisplayName = '',
    this.receivedByUserId = '',
  });

  final String eventId;
  final DateTime timestamp;
  final String eventType;
  final RiskLevel riskLevel;
  final FallStatus fallStatus;
  final PacketState state;
  final ConnectivityStatus connectivityAtCreation;
  final MovementState? movement;
  final double? heartRateBpm;
  final double? spo2Percent;
  final double? batteryPercent;
  final double? latitude;
  final double? longitude;
  final String originDeviceId;
  final int hopCount;
  final DateTime? expiresAt;
  final String? modelVersion;
  final double? riskScore;
  final String? contextLabel;
  final double? contextConfidence;
  final double? baselineHeartRate;
  final double? baselineSpo2;
  final double? windowHeartRateMean;
  final double? rulesScore;
  final double? modelContribution;
  final String? sensorSourceId;
  final String? sensorSourceKind;
  final String fallDetectionMode;
  final String ownerUserId;
  final String originDisplayName;
  final String receivedByUserId;

  bool get locationAvailable => latitude != null && longitude != null;

  bool get isReceivedNearby =>
      receivedByUserId.isNotEmpty && receivedByUserId != ownerUserId;

  EmergencyPacket copyWith({
    PacketState? state,
    int? hopCount,
    ConnectivityStatus? connectivityAtCreation,
    double? latitude,
    double? longitude,
    String? ownerUserId,
    String? originDisplayName,
    String? receivedByUserId,
    String? fallDetectionMode,
  }) {
    return EmergencyPacket(
      eventId: eventId,
      timestamp: timestamp,
      eventType: eventType,
      riskLevel: riskLevel,
      fallStatus: fallStatus,
      state: state ?? this.state,
      connectivityAtCreation:
          connectivityAtCreation ?? this.connectivityAtCreation,
      movement: movement,
      heartRateBpm: heartRateBpm,
      spo2Percent: spo2Percent,
      batteryPercent: batteryPercent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      originDeviceId: originDeviceId,
      hopCount: hopCount ?? this.hopCount,
      expiresAt: expiresAt,
      modelVersion: modelVersion,
      riskScore: riskScore,
      contextLabel: contextLabel,
      contextConfidence: contextConfidence,
      baselineHeartRate: baselineHeartRate,
      baselineSpo2: baselineSpo2,
      windowHeartRateMean: windowHeartRateMean,
      rulesScore: rulesScore,
      modelContribution: modelContribution,
      sensorSourceId: sensorSourceId,
      sensorSourceKind: sensorSourceKind,
      fallDetectionMode: fallDetectionMode ?? this.fallDetectionMode,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      originDisplayName: originDisplayName ?? this.originDisplayName,
      receivedByUserId: receivedByUserId ?? this.receivedByUserId,
    );
  }
}
