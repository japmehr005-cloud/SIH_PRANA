import 'package:aarogya/domain/emergency/disaster_activation_source.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';

sealed class EmergencyCommand {
  const EmergencyCommand();
}

final class ActivateDisaster extends EmergencyCommand {
  const ActivateDisaster({required this.disasterType, required this.source});

  final DisasterType disasterType;
  final DisasterActivationSource source;
}

final class ConfirmDisaster extends EmergencyCommand {
  const ConfirmDisaster();
}

final class EnterSurvival extends EmergencyCommand {
  const EnterSurvival();
}

final class RecordEmergencyEvent extends EmergencyCommand {
  const RecordEmergencyEvent({required this.eventId});

  final String eventId;
}

final class ResolveEmergency extends EmergencyCommand {
  const ResolveEmergency();
}

final class ResetToNormal extends EmergencyCommand {
  const ResetToNormal();
}
