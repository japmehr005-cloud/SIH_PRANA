enum EmergencyPhase {
  normal,
  disasterAlert,
  disasterActive,
  survival,
  emergencyEvent,
  resolved,
}

extension EmergencyPhaseX on EmergencyPhase {
  bool get isEmergencyActive =>
      this == EmergencyPhase.disasterAlert ||
      this == EmergencyPhase.disasterActive ||
      this == EmergencyPhase.survival ||
      this == EmergencyPhase.emergencyEvent;

  bool get isSurvivalFocused =>
      this == EmergencyPhase.survival || this == EmergencyPhase.emergencyEvent;
}
