import 'package:aarogya/domain/emergency/disaster_activation_source.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';

final class EmergencySnapshot {
  const EmergencySnapshot({
    required this.phase,
    required this.updatedAt,
    this.disasterType,
    this.activationSource,
    this.lastEventId,
    this.stranded = false,
    this.userId,
  });

  factory EmergencySnapshot.normal(DateTime updatedAt) {
    return EmergencySnapshot(
      phase: EmergencyPhase.normal,
      updatedAt: updatedAt,
    );
  }

  final EmergencyPhase phase;
  final DisasterType? disasterType;
  final DisasterActivationSource? activationSource;
  final DateTime updatedAt;
  final String? lastEventId;
  final bool stranded;
  final String? userId;

  EmergencySnapshot copyWith({
    EmergencyPhase? phase,
    DisasterType? disasterType,
    DisasterActivationSource? activationSource,
    DateTime? updatedAt,
    String? lastEventId,
    bool? stranded,
    String? userId,
    bool clearDisaster = false,
    bool clearEvent = false,
  }) {
    return EmergencySnapshot(
      phase: phase ?? this.phase,
      disasterType: clearDisaster ? null : disasterType ?? this.disasterType,
      activationSource: clearDisaster
          ? null
          : activationSource ?? this.activationSource,
      updatedAt: updatedAt ?? this.updatedAt,
      lastEventId: clearEvent ? null : lastEventId ?? this.lastEventId,
      stranded: stranded ?? this.stranded,
      userId: userId ?? this.userId,
    );
  }
}
