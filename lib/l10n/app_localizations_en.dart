// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PRANA';

  @override
  String get home => 'Home';

  @override
  String get demo => 'Continue';

  @override
  String get rescue => 'Rescue';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get loading => 'Loading PRANA';

  @override
  String get errorContinue =>
      'The current session can continue on this device.';

  @override
  String get invalidTransition =>
      'That action is not available in the current state.';

  @override
  String get phaseNormal => 'Normal';

  @override
  String get phaseDisasterAlert => 'Disaster alert';

  @override
  String get phaseDisasterActive => 'Disaster active';

  @override
  String get phaseSurvival => 'Survival';

  @override
  String get phaseEmergencyEvent => 'Emergency event';

  @override
  String get phaseResolved => 'Resolved';

  @override
  String get healthStatus => 'Health status';

  @override
  String get personalBaseline => 'Personal baseline';

  @override
  String get currentReadings => 'Current readings';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get heartRate => 'Heart rate';

  @override
  String get spo2 => 'SpO2';

  @override
  String get temperature => 'Temperature';

  @override
  String get activity => 'Activity';

  @override
  String get riskLevel => 'Risk level';

  @override
  String get riskLow => 'LOW';

  @override
  String get riskModerate => 'MODERATE';

  @override
  String get riskHigh => 'HIGH';

  @override
  String get riskCritical => 'CRITICAL';

  @override
  String get baselineNotReady =>
      'No health history available yet. Continue using PRANA to establish your personal baseline.';

  @override
  String get baselineReady =>
      'Personal baseline established from your recent resting readings.';

  @override
  String get bpmUnit => 'BPM';

  @override
  String get percentUnit => '%';

  @override
  String get celsiusUnit => 'C';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get internetUnavailable => 'Internet unavailable';

  @override
  String get localMonitoringActive => 'Local monitoring active';

  @override
  String get emergencyStoredLocally => 'Emergency event saved on this device.';

  @override
  String get emergencyQueued => 'Emergency event queued.';

  @override
  String get emergencyTransmitting => 'Emergency event transmitting.';

  @override
  String get emergencyTransmitted => 'Emergency event transmitted.';

  @override
  String get deliveryConfirmed => 'Delivery confirmed.';

  @override
  String get emergencyFailed =>
      'Emergency transmission failed. The event remains stored locally.';

  @override
  String get connectivity => 'Connectivity';

  @override
  String get battery => 'Battery';

  @override
  String get location => 'Location';

  @override
  String get locationUnavailable => 'Location unavailable.';

  @override
  String get lastKnownLocation => 'Last known location';

  @override
  String get fallStatus => 'Fall status';

  @override
  String get fallStatusNone => 'No fall detected';

  @override
  String get possibleFallDetected => 'Possible fall detected.';

  @override
  String get awaitingFallConfirmation =>
      'Possible fall detected. Please confirm you are safe.';

  @override
  String get criticalEvent => 'CRITICAL EVENT';

  @override
  String get iAmOk => 'I am safe';

  @override
  String get connectivityOnline => 'Connected';

  @override
  String get connectivityOffline => 'Offline';

  @override
  String get connectivityLimited => 'Limited connectivity';

  @override
  String get connectivityUnknown => 'Unknown';

  @override
  String get flood => 'Flood';

  @override
  String get officialWarning => 'Official warning';

  @override
  String get immediateAction => 'Immediate action';

  @override
  String get floodAction => 'Move toward a suitable safer location.';

  @override
  String get floodAvoidWater => 'Avoid moving water.';

  @override
  String get floodAvoidElectrical => 'Avoid flooded electrical areas.';

  @override
  String get floodFollowGuidance =>
      'Follow known evacuation guidance where available.';

  @override
  String get floodDoNotAssumeAltitude =>
      'Do not treat altitude alone as proof of safety.';

  @override
  String get floodAvoidBridges => 'Avoid damaged bridges and flooded roads.';

  @override
  String get floodConserveBattery => 'Conserve battery.';

  @override
  String get floodKeepCommunication =>
      'Keep emergency communication available.';

  @override
  String get floodSeverity => 'Severity';

  @override
  String get floodSeverityHigh => 'High';

  @override
  String get floodWarningIssued => 'Official flood warning';

  @override
  String get connectivityRestored => 'Connectivity restored';

  @override
  String get timeSinceLastCommunication => 'Time since last communication';

  @override
  String get lastCommunicationUnknown => 'Last communication time unavailable.';

  @override
  String get baselineConfidence => 'Baseline history';

  @override
  String get sensorAvailability => 'Sensor availability';

  @override
  String get demoResetFull => 'Reset demo to Normal Mode';

  @override
  String get demoSequenceTitle => 'SIH flood demonstration';

  @override
  String get demoStageComplete => 'Completed';

  @override
  String get demoStageCurrent => 'Current step';

  @override
  String get demoStage1Title => 'Stage 1. Normal Mode';

  @override
  String get demoStage2Title => 'Stage 2. Official flood warning';

  @override
  String get demoStage3Title => 'Stage 3. Disaster active';

  @override
  String get demoStage4Title => 'Stage 4. Connectivity failure';

  @override
  String get demoStage5Title => 'Stage 5. Survival Mode';

  @override
  String get demoStage6Title => 'Stage 6. Fall and deterioration';

  @override
  String get demoStage7Title => 'Stage 7. Emergency packet';

  @override
  String get demoStage8Title => 'Stage 8. Connectivity restored';

  @override
  String get demoStage9Title => 'Stage 9. Rescue dashboard';

  @override
  String get demoStage1Body =>
      'Replay labeled normal readings. PRANA learns a personal baseline through the real inference pipeline.';

  @override
  String get demoStage2Body =>
      'Inject an official flood warning. PRANA moves from Normal to Disaster alert.';

  @override
  String get demoStage3Body =>
      'Confirm the disaster. Structured flood guidance is shown from the local catalog.';

  @override
  String get demoStage4Body =>
      'Simulate loss of internet and backend connectivity. Monitoring and guidance stay on this device.';

  @override
  String get demoStage5Body =>
      'The user is stranded. Survival Mode continues local monitoring without a cloud round trip.';

  @override
  String get demoStage6Body =>
      'Replay deterioration and fall sensor sequences. Fall detection still requires spike, impact, orientation, inactivity, and confirmation.';

  @override
  String get demoStage7Body =>
      'Create the emergency record through the application pipeline. It is stored locally and is not marked delivered.';

  @override
  String get demoStage8Body =>
      'Restore simulated connectivity. Store-and-forward moves the packet only after the transport confirms delivery.';

  @override
  String get demoStage9Body =>
      'Open the Rescue view of the same stored packet. This is not a separate fake object.';

  @override
  String get demoNextStage => 'Continue';

  @override
  String get demoPreviousStage => 'Previous stage';

  @override
  String get demoAutoPlay => 'Play remaining stages';

  @override
  String get demoStopAutoPlay => 'Stop';

  @override
  String demoStageProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get simulatedConnectivity =>
      'Connectivity shown here is simulated for the prototype.';

  @override
  String get recentHealthEvents => 'Recent health events';

  @override
  String get noRecentHealthEvents =>
      'No health events have been recorded in this session yet.';

  @override
  String get aboutAarogya => 'About PRANA';

  @override
  String get appVersionLabel => 'Version';

  @override
  String get appVersionValue => '0.1.0';

  @override
  String get presentationTarget =>
      'The SIH presentation target is this browser demo. The long-term product remains a mobile companion.';

  @override
  String get medicalDisclaimerShort =>
      'PRANA is a risk detection and emergency assistance system. It is not a medical diagnostic system.';

  @override
  String get packetStoredLocally => 'Stored locally';

  @override
  String get packetPendingDelivery => 'Pending transmission';

  @override
  String get packetDelivered => 'Delivered';

  @override
  String get openRescueDashboard => 'Open rescue dashboard';

  @override
  String get rescueEmptyHint =>
      'No emergency packet is stored yet. Use the demonstration to generate one through the application pipeline.';

  @override
  String get demoSessionState => 'Current session';

  @override
  String get webPresentationHint =>
      'Each step injects data or an official event into the real PRANA pipeline.';

  @override
  String get simulationData => 'Demonstration data';

  @override
  String get simulationNotice =>
      'These readings are labeled demonstration data and are not clinical evidence.';

  @override
  String get demoTitle => 'Demonstration controls';

  @override
  String get demoReplayNormal => 'Replay normal baseline dataset';

  @override
  String get demoFloodWarning => 'Inject official flood warning';

  @override
  String get demoConfirmDisaster => 'Confirm disaster active';

  @override
  String get demoReplayFlood => 'Replay flood exertion dataset';

  @override
  String get demoGoOffline => 'Set connectivity offline';

  @override
  String get demoEnterSurvival => 'Enter survival mode';

  @override
  String get demoReplayDeterioration => 'Replay physiological deterioration';

  @override
  String get demoReplayFall => 'Replay fall sequence';

  @override
  String get demoRestoreConnectivity => 'Restore connectivity';

  @override
  String get demoEscalateFall => 'Escalate unconfirmed fall';

  @override
  String get demoResolve => 'Resolve emergency';

  @override
  String get demoReset => 'Return to normal';

  @override
  String get rescueDashboard => 'Emergency Response';

  @override
  String get noEmergencyPackets =>
      'No emergency packets have been stored or received.';

  @override
  String get packetState => 'Packet state';

  @override
  String get eventType => 'Event type';

  @override
  String get eventId => 'Event identifier';

  @override
  String get eventTimestamp => 'Timestamp';

  @override
  String get communicationStatus => 'Communication status';

  @override
  String get deviceId => 'Device';

  @override
  String get whatHappened => 'What happened';

  @override
  String get howSerious => 'How serious';

  @override
  String get whatToDo => 'What you should do';

  @override
  String get movementNone => 'None';

  @override
  String get movementLow => 'Low';

  @override
  String get movementNormal => 'Normal';

  @override
  String get movementHigh => 'High';

  @override
  String get movementIrregular => 'Irregular';

  @override
  String get reasonHrAboveBaseline =>
      'Heart rate is significantly above your usual baseline.';

  @override
  String get reasonSpo2BelowBaseline =>
      'SpO2 has decreased from your recent baseline.';

  @override
  String get reasonProlongedActivity => 'Prolonged physical activity detected.';

  @override
  String get reasonHighHrLowMovement =>
      'Heart rate is elevated while movement is low.';

  @override
  String get reasonEnvironmentalStress =>
      'Disaster conditions increase the significance of current readings.';

  @override
  String get reasonLimitedSensors =>
      'Some sensors are unavailable. Risk is based on remaining signals.';

  @override
  String get reasonInsufficientHistory =>
      'There is not enough personal history to score risk yet.';

  @override
  String get reasonPossibleFall => 'A possible fall sequence was detected.';

  @override
  String get reasonModelExertion =>
      'Heart-rate change is being interpreted with physical activity in mind.';

  @override
  String get reasonModelElevatedLoad =>
      'Your readings differ from your usual rest pattern.';

  @override
  String get readingsDifferFromBaseline =>
      'Your current readings differ significantly from your usual baseline.';

  @override
  String get elevatedHealthRisk => 'Elevated health risk detected.';

  @override
  String get emergencyEventRecorded => 'Emergency event recorded.';

  @override
  String get engineVersion => 'Engine version';

  @override
  String get homeGuidanceNormal =>
      'Continue routine monitoring. PRANA stays on this device.';

  @override
  String get continueUsing => 'Continue using PRANA.';

  @override
  String get disasterType => 'Disaster type';

  @override
  String get activationSource => 'Activation source';

  @override
  String get userActivation => 'User activation';

  @override
  String get localDetection => 'Supported local detection';

  @override
  String get productTagline => 'Personal Health & Emergency Assistance';

  @override
  String get startDisasterDemo => 'Start disaster demo';

  @override
  String get simulationBadge => 'Demonstration data';

  @override
  String stageHeroLabel(String number) {
    return 'STAGE $number';
  }

  @override
  String get stageShort1 => 'Your health';

  @override
  String get stageShort2 => 'Emergency';

  @override
  String get stageShort3 => 'Safer place';

  @override
  String get stageShort4 => 'Need help?';

  @override
  String get stageShort5 => 'Nearby';

  @override
  String get stageShort6 => 'Response';

  @override
  String get stageShort7 => 'Emergency Packet';

  @override
  String get stageShort8 => 'Communication Restored';

  @override
  String get stageShort9 => 'Rescue';

  @override
  String get demoStage1Hero => 'Your health';

  @override
  String get demoStage1HeroBody =>
      'Review your usual readings and the current health assessment.';

  @override
  String get demoStage2Hero => 'Emergency';

  @override
  String get demoStage2HeroBody =>
      'An official flood warning is now active. Follow the guidance on this screen.';

  @override
  String get demoStage3Hero => 'Safer location';

  @override
  String get demoStage3HeroBody =>
      'A recommended safer place is shown with the reason it was chosen.';

  @override
  String get demoStage4Hero => 'Need help?';

  @override
  String get demoStage4HeroBody =>
      'A possible fall was detected. Confirm whether you need help.';

  @override
  String get demoStage5Hero => 'Nearby PRANA users';

  @override
  String get demoStage5HeroBody =>
      'Receive or forward emergency information with nearby PRANA users.';

  @override
  String get demoStage6Hero => 'Emergency response';

  @override
  String get demoStage6HeroBody =>
      'Open the responder view of the same emergency record.';

  @override
  String get demoStage7Hero => 'EMERGENCY PACKET';

  @override
  String get demoStage7HeroBody =>
      'The emergency record is stored on this device until a communication path is available.';

  @override
  String get demoStage8Hero => 'COMMUNICATION RESTORED';

  @override
  String get demoStage8HeroBody =>
      'Simulated connectivity has returned. The packet moves only after the transport confirms delivery.';

  @override
  String get demoStage9Hero => 'RESCUE DASHBOARD';

  @override
  String get demoStage9HeroBody =>
      'Rescue view shows the same stored emergency packet generated by the demonstration.';

  @override
  String get modeChipNormal => 'NORMAL';

  @override
  String get modeChipDisasterAlert => 'DISASTER ALERT';

  @override
  String get modeChipDisasterActive => 'DISASTER ACTIVE';

  @override
  String get modeChipSurvival => 'SURVIVAL';

  @override
  String get modeChipEmergency => 'EMERGENCY';

  @override
  String get modeChipResolved => 'RESOLVED';

  @override
  String get capabilityLocalMonitoring => 'Local monitoring';

  @override
  String get capabilityLocalInference => 'Local assessment';

  @override
  String get capabilityLocalStorage => 'Local storage';

  @override
  String get capabilityDisasterGuidance => 'Disaster guidance';

  @override
  String get capabilityEmergencyProcessing => 'Emergency processing';

  @override
  String get capabilityActive => 'Active';

  @override
  String get capabilityAvailable => 'Available';

  @override
  String get networkLabel => 'Network';

  @override
  String get fallStepSpike => 'Movement spike';

  @override
  String get fallStepImpact => 'Impact detected';

  @override
  String get fallStepOrientation => 'Orientation change';

  @override
  String get fallStepInactivity => 'Inactivity detected';

  @override
  String get fallStepConfirmation => 'Confirmation window';

  @override
  String get fallStepEmergency => 'Emergency event confirmed';

  @override
  String get packetLocalOnly => 'Local only';

  @override
  String get packetPending => 'Pending';

  @override
  String get packetSentDelivered => 'Sent / Delivered';

  @override
  String get affectedArea => 'Affected area';

  @override
  String get demoLocationKathmandu => 'Kathmandu valley demonstration area';

  @override
  String get confidenceLabel => 'Confidence';

  @override
  String get inferenceSource => 'Inference source';

  @override
  String get inferenceTrainedModel => 'On-device trained model';

  @override
  String get inferenceRulesOnly => 'Baseline rules only';

  @override
  String get physioContext => 'Physiological context';

  @override
  String get physioContextRest => 'Rest';

  @override
  String get physioContextExertion => 'Exertion';

  @override
  String get physioContextElevatedLoad => 'Elevated load';

  @override
  String get modelConfidence => 'Model confidence';

  @override
  String get researchRecording => 'Research recording';

  @override
  String get riskScoreLabel => 'Risk score';

  @override
  String get sensorSourceLabel => 'Sensor source';

  @override
  String get sensorSourceSimulation => 'Demonstration data';

  @override
  String get sensorSourceDataset => 'Research recording';

  @override
  String get sensorSourceWearable => 'Wearable';

  @override
  String get recentHeartRate => 'Recent heart rate';

  @override
  String get heartRateNowUsual => 'Heart rate now / usual';

  @override
  String get spo2NowUsual => 'SpO2 now / usual';

  @override
  String get windowHeartRate => 'Recent window heart rate';

  @override
  String get riskInputs => 'Risk inputs';

  @override
  String riskInputsValue(String rules, String model) {
    return 'Rules $rules · trained context $model';
  }

  @override
  String get fallCheck => 'Fall check';

  @override
  String get fallCheckSimulated => 'Fall detection: demonstration mode';

  @override
  String get assessmentWhyHeading => 'Why this assessment';

  @override
  String alertHrVsBaseline(String current, String usual) {
    return 'Heart rate is $current BPM compared with usual rest $usual BPM.';
  }

  @override
  String alertSpo2VsBaseline(String current, String usual) {
    return 'SpO2 is $current% compared with usual $usual%.';
  }

  @override
  String alertModelDetected(String context, String confidence) {
    return 'Health assessment: $context ($confidence% confidence).';
  }

  @override
  String get alertRiskCombined =>
      'Risk increased from current measurements and your personal baseline.';

  @override
  String get modelPipelineNote =>
      'Assessment based on your recent readings and personal baseline.';

  @override
  String get usualRestHeartRate => 'Usual rest heart rate';

  @override
  String get usualRestSpo2 => 'Usual rest SpO2';

  @override
  String get fallDetectionMode => 'Fall detection';

  @override
  String get fallDetectionSimulated => 'Demonstration mode';

  @override
  String get yourHealth => 'Your Health';

  @override
  String get emergencyInformation => 'Emergency Information';

  @override
  String get emergencyAssistance => 'Emergency Assistance';

  @override
  String get emergencyResponse => 'Emergency Response';

  @override
  String get healthAssessment => 'Health assessment';

  @override
  String get assessmentConfidence => 'Assessment confidence';

  @override
  String get assessmentFromReadings =>
      'Assessment based on your recent readings and personal baseline.';

  @override
  String get demonstrationData => 'Demonstration data';

  @override
  String get technicalInformation => 'Technical information';

  @override
  String get technicalInformationHint =>
      'For evaluation only. These details are not shown in the public health screens.';

  @override
  String get accountSection => 'Account';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create an account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full name';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get needAccount => 'Need an account? Register';

  @override
  String get signedInAs => 'Signed in as';

  @override
  String get sessionPersistsHint =>
      'Your account stays signed in on this device until you sign out.';

  @override
  String get dataStaysOnDevice =>
      'Health assessment stays on this device. Signed-in sync stores only the records needed for your account.';

  @override
  String get authRequiredHint => 'Sign in to use PRANA on this device.';

  @override
  String get passwordTooShort => 'Use a password with at least 8 characters.';

  @override
  String get invalidCredentials =>
      'That email or password could not be verified.';

  @override
  String get registrationFailed =>
      'The account could not be created. Try a different email.';

  @override
  String get nameRequired => 'Enter your name.';

  @override
  String get emailRequired => 'Enter a valid email address.';

  @override
  String get deviceIdentifier => 'Device identifier';

  @override
  String get userIdentifier => 'User identifier';

  @override
  String get peerNetworkNotActive =>
      'Nearby sharing uses a same-origin browser demonstration relay stored on this device. It is not Bluetooth or mesh radio.';

  @override
  String get publicLandingBody =>
      'Sign in to keep your baseline and emergency information on this account.';

  @override
  String get syncWhenConnected =>
      'Emergency information is stored on this device first, then synchronized when connectivity is available.';

  @override
  String get emailOrMobile => 'Email / Mobile';

  @override
  String get identifierRequired =>
      'Enter a valid email address or mobile number.';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get continueAsDemoUser => 'Continue as demonstration user';

  @override
  String get demoAccountHint =>
      'This opens a demonstration account. It still uses the same health and emergency pipeline, and it stays separate from personal accounts.';

  @override
  String get myAccount => 'My Account';

  @override
  String get accountNav => 'Account';

  @override
  String get accountIdentifier => 'Account';

  @override
  String get healthDataStatus => 'Health data';

  @override
  String get emergencyRecords => 'Emergency records';

  @override
  String get demonstrationAccount => 'Demonstration account';

  @override
  String get baselineReadyShort => 'Personal baseline established';

  @override
  String get baselineNotReadyShort => 'Personal baseline not established yet';

  @override
  String readingCount(int count) {
    return '$count stored readings';
  }

  @override
  String packetCount(int count) {
    return '$count emergency records';
  }

  @override
  String get duplicateAccount =>
      'An account with that email or mobile number already exists.';

  @override
  String get sensorSourceDevice => 'Connected device';

  @override
  String get nearbyAarogyaUsers => 'Nearby PRANA users';

  @override
  String get nearbyRelayHint =>
      'Nearby sharing on this device is a browser demonstration. It is not Bluetooth or mesh radio.';

  @override
  String get noNearbyUsers =>
      'No other signed-in PRANA sessions are sharing nearby right now.';

  @override
  String get forwardEmergency => 'Forward';

  @override
  String get forwardedNearby => 'Forwarded to nearby PRANA users';

  @override
  String get connectedDevice => 'Connected device';

  @override
  String get connectHeartRate => 'Connect heart-rate monitor';

  @override
  String get heartRateBrowserOnly =>
      'Heart-rate connection is available in browsers that support Bluetooth accessories. This is not Apple Watch or Fitbit pairing.';

  @override
  String get heartRateUnavailableBrowser =>
      'Heart-rate accessory connection is not available in this browser.';

  @override
  String get currentLocation => 'Current location';

  @override
  String get demonstrationLocation => 'Demonstration location';

  @override
  String get gpsLocation => 'Device location';

  @override
  String get requestLocation => 'Use device location';

  @override
  String get saferLocation => 'Safer location';

  @override
  String get saferLocationRecommended =>
      'Recommended based on available emergency and geographic information.';

  @override
  String get notDefinitelySafe =>
      'This does not mean the location is definitely safe.';

  @override
  String get directionAndDistance =>
      'Direction and distance from available coordinates. Not turn-by-turn street navigation.';

  @override
  String get mapTilesNeedNetwork =>
      'Map tiles need a network connection. Distance and direction still work from saved geographic information.';

  @override
  String get osmAttribution => 'Map tiles © OpenStreetMap contributors';

  @override
  String distanceAndBearing(String distance, String direction) {
    return '$distance m $direction';
  }

  @override
  String get insideHazardArea => 'You are inside a demonstration hazard area.';

  @override
  String get fallCheckOnDevice => 'Fall check: on-device assessment';

  @override
  String get receivedNearby => 'Received nearby';

  @override
  String get thisAccountEmergency => 'This account';

  @override
  String get eventTypePossibleFall => 'Possible fall';

  @override
  String get eventTypeDeterioration => 'Elevated health risk';

  @override
  String fromUser(String name) {
    return 'From $name';
  }

  @override
  String get nearbyRelayTechnical =>
      'Nearby sharing uses a same-origin browser demonstration relay (not Bluetooth).';

  @override
  String get inMemoryTransportTechnical =>
      'In-memory demonstration transport (tests).';

  @override
  String get accelAvailable => 'Movement sensors';

  @override
  String get gyroAvailable => 'Rotation sensors';

  @override
  String get availableShort => 'Available';

  @override
  String get sourceLabel => 'Source';

  @override
  String get iNeedHelp => 'I need help';

  @override
  String get fallCheckCancelled =>
      'Fall check cancelled. No emergency packet was created.';

  @override
  String get receiveEmergency => 'Receive';

  @override
  String get emergencyInformationAvailable => 'Emergency information available';

  @override
  String get nearbySharingHint =>
      'Nearby sharing on this device is a browser demonstration. It is not Bluetooth or mesh radio.';

  @override
  String get noNearbySaferLocation => 'No nearby safer location identified.';

  @override
  String get recommendedSaferLocation => 'Recommended safer location';

  @override
  String get directionToSaferLocation => 'Direction to safer location';

  @override
  String get demonstrationAreaKathmandu => 'Kathmandu flood area';

  @override
  String get demonstrationAreaDelhi => 'Delhi area';

  @override
  String get locationOutsideDemonstration =>
      'Device location is outside the configured demonstration areas. The current demonstration area is unchanged.';

  @override
  String get replayDemonstrationReadings => 'Replay demonstration readings';

  @override
  String get currentSituation => 'Current situation';

  @override
  String get currentCondition => 'Current condition';

  @override
  String get recommendedAction => 'Recommended action';

  @override
  String get assistanceStatus => 'Assistance status';

  @override
  String get myEmergencyInformation => 'My emergency information';

  @override
  String get selectSaferLocation => 'Select a safer location';

  @override
  String get bloodOxygen => 'Blood oxygen';

  @override
  String get limitedConnectivity => 'Limited connectivity';

  @override
  String get situationNormal => 'Normal';

  @override
  String get situationEmergency => 'Emergency';

  @override
  String get personLabel => 'Person';

  @override
  String get statusLabel => 'Status';

  @override
  String get timeLabel => 'Time';

  @override
  String get healthSummary => 'Health summary';

  @override
  String get pranaTaglineFull =>
      'Privacy-preserving Resilience & Adaptive Neural Assistant';

  @override
  String get useDeviceLocation => 'Use device location';

  @override
  String get demonstrationConditions => 'Demonstration conditions';

  @override
  String get conditionResting => 'Resting';

  @override
  String get conditionPhysicalActivity => 'Physical activity';

  @override
  String get conditionHighLoad => 'High load';

  @override
  String get conditionFallImpact => 'Fall / impact';

  @override
  String get whyRecommended => 'Why this place is recommended';

  @override
  String get mapLegendYou => 'You are here';

  @override
  String get mapLegendAffected => 'Affected area';

  @override
  String get mapLegendSafer => 'Recommended safer location';

  @override
  String get reasonOutsideHazard => 'This place is outside the affected area.';

  @override
  String get reasonOpenSpace => 'This is an open space.';

  @override
  String get reasonNearestInRegion =>
      'This is the nearest suitable place in this area.';

  @override
  String get reasonUnderGuidanceLimit =>
      'It is within the local 15 km guidance range.';

  @override
  String get howItReachedUs => 'How it reached us';

  @override
  String get reachedFromThisAccount => 'Recorded on this account.';

  @override
  String get reachedFromNearbyUser => 'Received from a nearby PRANA user.';

  @override
  String get urgencyLabel => 'Urgency';

  @override
  String get pranaAssistant => 'PRANA Assistant';

  @override
  String get assistantHowCanIHelp => 'How can I help?';

  @override
  String get assistantAskHint => 'Ask about this session';

  @override
  String get assistantAsk => 'Ask';

  @override
  String get assistantUnrecognized =>
      'I don\'t have enough information to answer that from your current PRANA data.';

  @override
  String get assistantInsufficient =>
      'I don\'t have enough information to answer that from your current PRANA data.';

  @override
  String get assistantCanHelpWith =>
      'I can explain your current readings, usual pattern, safer location, and emergency guidance.';

  @override
  String get assistantReadingsClose =>
      'Your recent readings are close to your usual pattern. No significant change from your current baseline has been identified.';

  @override
  String get assistantRestAndRecheck =>
      'If you have recently been active, rest for a few minutes and check again.';

  @override
  String get assistantFallExplain =>
      'PRANA detected a movement pattern that may indicate a fall. Please confirm that you are safe.';

  @override
  String get assistantEmergencyAttention =>
      'Your current situation requires attention. PRANA has your emergency information and current location available. Follow the recommended safety guidance.';

  @override
  String get assistantOfflineLocal =>
      'Local monitoring, health assessment, saved guidance, and emergency records still work on this device. Forwarding waits until a connection is available.';

  @override
  String get assistantNoSaferPlace =>
      'I don\'t currently have a suitable safer location available.';

  @override
  String assistantSaferPlaceApprox(
    String place,
    String meters,
    String direction,
  ) {
    return 'A recommended safer location is $place, approximately $meters metres $direction of your current location.';
  }

  @override
  String assistantUsualHr(String value) {
    return 'Your usual resting heart rate is $value BPM.';
  }

  @override
  String get assistantNearbyPresent =>
      'Nearby PRANA users can receive or forward emergency information on this device.';

  @override
  String get assistantStatusHeading => 'Your current health';

  @override
  String get assistantStatusNormal => 'Normal';

  @override
  String get assistantStatusElevated => 'Elevated';

  @override
  String get assistantStatusEmergency => 'Emergency';

  @override
  String get assistantSend => 'Send';

  @override
  String get askPranaAssistant => 'Ask PRANA Assistant';

  @override
  String get healthNav => 'Health';

  @override
  String get assistantNav => 'Assistant';

  @override
  String get moreNav => 'More';

  @override
  String get openHealth => 'Open Health';

  @override
  String get continueDemonstration => 'Continue demonstration';

  @override
  String get compassNorth => 'north';

  @override
  String get compassNorthEast => 'northeast';

  @override
  String get compassEast => 'east';

  @override
  String get compassSouthEast => 'southeast';

  @override
  String get compassSouth => 'south';

  @override
  String get compassSouthWest => 'southwest';

  @override
  String get compassWest => 'west';

  @override
  String get compassNorthWest => 'northwest';

  @override
  String get assistantDemonstrationNote =>
      'These readings are demonstration data.';

  @override
  String get assistantQuestionWhyStatus => 'Why did my status change?';

  @override
  String get assistantQuestionWhatChanged =>
      'What changed from my usual readings?';

  @override
  String get assistantQuestionAmIOkay => 'Am I okay?';

  @override
  String get assistantQuestionWhatShouldIDo => 'What should I do?';

  @override
  String get assistantQuestionWhereToGo => 'Where should I go?';

  @override
  String get assistantQuestionWhatIfHelp => 'What if I need help?';

  @override
  String get assistantQuestionEmergency =>
      'What should I do in this emergency?';

  @override
  String get assistantQuestionWhyAlerted => 'Why was I alerted?';

  @override
  String get assistantHeadlineHealth => 'Your current health';

  @override
  String get assistantHeadlineEmergency => 'Current emergency';

  @override
  String get assistantHeadlineFall => 'Possible fall check';

  @override
  String get assistantHrHigherUsual =>
      'Your recent heart rate is higher than your usual resting pattern.';

  @override
  String get assistantHrSimilarUsual =>
      'Your recent heart rate is close to your usual resting pattern.';

  @override
  String get assistantHrLowerUsual =>
      'Your recent heart rate is lower than your usual resting pattern.';

  @override
  String get assistantSpo2LowerUsual =>
      'Your recent blood oxygen is lower than your usual pattern.';

  @override
  String get assistantSpo2SimilarUsual =>
      'Your recent blood oxygen is close to your usual pattern.';

  @override
  String get assistantReadingsUnavailable =>
      'Current readings are unavailable.';

  @override
  String get assistantBaselineNotReady =>
      'A personal baseline is not ready yet.';

  @override
  String get assistantLocationUnavailable =>
      'Safer-location guidance is unavailable.';

  @override
  String get assistantNoDisaster =>
      'No disaster warning is active on this device.';

  @override
  String assistantSituationLine(String phase) {
    return 'Current situation: $phase.';
  }

  @override
  String assistantDisasterLine(String disaster) {
    return 'Active warning: $disaster.';
  }

  @override
  String get assistantAssistanceLimited =>
      'Assistance stays on this device while connectivity is limited.';

  @override
  String get assistantAssistanceOnline =>
      'Emergency information can be forwarded when a path is available.';

  @override
  String get assistantPacketPresent =>
      'An emergency event is recorded on this device.';

  @override
  String get assistantPacketAbsent =>
      'No emergency assistance request is recorded yet.';

  @override
  String get assistantConfirmSafe => 'Please confirm whether you are safe.';

  @override
  String get assistantContextElevated =>
      'The current assessment context is elevated load.';

  @override
  String get assistantContextExertion =>
      'The current assessment context is exertion.';

  @override
  String get assistantContextRest => 'The current assessment context is rest.';

  @override
  String get assistantNotADiagnosis =>
      'This is a risk assessment, not a medical diagnosis.';

  @override
  String get assistantHelpPath =>
      'If you need help, use I need help to record an emergency event on this device.';

  @override
  String assistantGoToPlace(String place) {
    return 'Recommended safer place: $place.';
  }

  @override
  String get assistantTechnicalTitle => 'On-device assistant';

  @override
  String get assistantTechnicalBody =>
      'Uses session state, disaster guidance, and location guidance on this device. Does not call a cloud language model.';
}
