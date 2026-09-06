import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PRANA'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @demo.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get demo;

  /// No description provided for @rescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get rescue;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading PRANA'**
  String get loading;

  /// No description provided for @errorContinue.
  ///
  /// In en, this message translates to:
  /// **'The current session can continue on this device.'**
  String get errorContinue;

  /// No description provided for @invalidTransition.
  ///
  /// In en, this message translates to:
  /// **'That action is not available in the current state.'**
  String get invalidTransition;

  /// No description provided for @phaseNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get phaseNormal;

  /// No description provided for @phaseDisasterAlert.
  ///
  /// In en, this message translates to:
  /// **'Disaster alert'**
  String get phaseDisasterAlert;

  /// No description provided for @phaseDisasterActive.
  ///
  /// In en, this message translates to:
  /// **'Disaster active'**
  String get phaseDisasterActive;

  /// No description provided for @phaseSurvival.
  ///
  /// In en, this message translates to:
  /// **'Survival'**
  String get phaseSurvival;

  /// No description provided for @phaseEmergencyEvent.
  ///
  /// In en, this message translates to:
  /// **'Emergency event'**
  String get phaseEmergencyEvent;

  /// No description provided for @phaseResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get phaseResolved;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health status'**
  String get healthStatus;

  /// No description provided for @personalBaseline.
  ///
  /// In en, this message translates to:
  /// **'Personal baseline'**
  String get personalBaseline;

  /// No description provided for @currentReadings.
  ///
  /// In en, this message translates to:
  /// **'Current readings'**
  String get currentReadings;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart rate'**
  String get heartRate;

  /// No description provided for @spo2.
  ///
  /// In en, this message translates to:
  /// **'SpO2'**
  String get spo2;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk level'**
  String get riskLevel;

  /// No description provided for @riskLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get riskLow;

  /// No description provided for @riskModerate.
  ///
  /// In en, this message translates to:
  /// **'MODERATE'**
  String get riskModerate;

  /// No description provided for @riskHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get riskHigh;

  /// No description provided for @riskCritical.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get riskCritical;

  /// No description provided for @baselineNotReady.
  ///
  /// In en, this message translates to:
  /// **'No health history available yet. Continue using PRANA to establish your personal baseline.'**
  String get baselineNotReady;

  /// No description provided for @baselineReady.
  ///
  /// In en, this message translates to:
  /// **'Personal baseline established from your recent resting readings.'**
  String get baselineReady;

  /// No description provided for @bpmUnit.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpmUnit;

  /// No description provided for @percentUnit.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get percentUnit;

  /// No description provided for @celsiusUnit.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get celsiusUnit;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @internetUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Internet unavailable'**
  String get internetUnavailable;

  /// No description provided for @localMonitoringActive.
  ///
  /// In en, this message translates to:
  /// **'Local monitoring active'**
  String get localMonitoringActive;

  /// No description provided for @emergencyStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Emergency event saved on this device.'**
  String get emergencyStoredLocally;

  /// No description provided for @emergencyQueued.
  ///
  /// In en, this message translates to:
  /// **'Emergency event queued.'**
  String get emergencyQueued;

  /// No description provided for @emergencyTransmitting.
  ///
  /// In en, this message translates to:
  /// **'Emergency event transmitting.'**
  String get emergencyTransmitting;

  /// No description provided for @emergencyTransmitted.
  ///
  /// In en, this message translates to:
  /// **'Emergency event transmitted.'**
  String get emergencyTransmitted;

  /// No description provided for @deliveryConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed.'**
  String get deliveryConfirmed;

  /// No description provided for @emergencyFailed.
  ///
  /// In en, this message translates to:
  /// **'Emergency transmission failed. The event remains stored locally.'**
  String get emergencyFailed;

  /// No description provided for @connectivity.
  ///
  /// In en, this message translates to:
  /// **'Connectivity'**
  String get connectivity;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable.'**
  String get locationUnavailable;

  /// No description provided for @lastKnownLocation.
  ///
  /// In en, this message translates to:
  /// **'Last known location'**
  String get lastKnownLocation;

  /// No description provided for @fallStatus.
  ///
  /// In en, this message translates to:
  /// **'Fall status'**
  String get fallStatus;

  /// No description provided for @fallStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No fall detected'**
  String get fallStatusNone;

  /// No description provided for @possibleFallDetected.
  ///
  /// In en, this message translates to:
  /// **'Possible fall detected.'**
  String get possibleFallDetected;

  /// No description provided for @awaitingFallConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Possible fall detected. Please confirm you are safe.'**
  String get awaitingFallConfirmation;

  /// No description provided for @criticalEvent.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL EVENT'**
  String get criticalEvent;

  /// No description provided for @iAmOk.
  ///
  /// In en, this message translates to:
  /// **'I am safe'**
  String get iAmOk;

  /// No description provided for @connectivityOnline.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectivityOnline;

  /// No description provided for @connectivityOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get connectivityOffline;

  /// No description provided for @connectivityLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited connectivity'**
  String get connectivityLimited;

  /// No description provided for @connectivityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get connectivityUnknown;

  /// No description provided for @flood.
  ///
  /// In en, this message translates to:
  /// **'Flood'**
  String get flood;

  /// No description provided for @officialWarning.
  ///
  /// In en, this message translates to:
  /// **'Official warning'**
  String get officialWarning;

  /// No description provided for @immediateAction.
  ///
  /// In en, this message translates to:
  /// **'Immediate action'**
  String get immediateAction;

  /// No description provided for @floodAction.
  ///
  /// In en, this message translates to:
  /// **'Move toward a suitable safer location.'**
  String get floodAction;

  /// No description provided for @floodAvoidWater.
  ///
  /// In en, this message translates to:
  /// **'Avoid moving water.'**
  String get floodAvoidWater;

  /// No description provided for @floodAvoidElectrical.
  ///
  /// In en, this message translates to:
  /// **'Avoid flooded electrical areas.'**
  String get floodAvoidElectrical;

  /// No description provided for @floodFollowGuidance.
  ///
  /// In en, this message translates to:
  /// **'Follow known evacuation guidance where available.'**
  String get floodFollowGuidance;

  /// No description provided for @floodDoNotAssumeAltitude.
  ///
  /// In en, this message translates to:
  /// **'Do not treat altitude alone as proof of safety.'**
  String get floodDoNotAssumeAltitude;

  /// No description provided for @floodAvoidBridges.
  ///
  /// In en, this message translates to:
  /// **'Avoid damaged bridges and flooded roads.'**
  String get floodAvoidBridges;

  /// No description provided for @floodConserveBattery.
  ///
  /// In en, this message translates to:
  /// **'Conserve battery.'**
  String get floodConserveBattery;

  /// No description provided for @floodKeepCommunication.
  ///
  /// In en, this message translates to:
  /// **'Keep emergency communication available.'**
  String get floodKeepCommunication;

  /// No description provided for @floodSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get floodSeverity;

  /// No description provided for @floodSeverityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get floodSeverityHigh;

  /// No description provided for @floodWarningIssued.
  ///
  /// In en, this message translates to:
  /// **'Official flood warning'**
  String get floodWarningIssued;

  /// No description provided for @connectivityRestored.
  ///
  /// In en, this message translates to:
  /// **'Connectivity restored'**
  String get connectivityRestored;

  /// No description provided for @timeSinceLastCommunication.
  ///
  /// In en, this message translates to:
  /// **'Time since last communication'**
  String get timeSinceLastCommunication;

  /// No description provided for @lastCommunicationUnknown.
  ///
  /// In en, this message translates to:
  /// **'Last communication time unavailable.'**
  String get lastCommunicationUnknown;

  /// No description provided for @baselineConfidence.
  ///
  /// In en, this message translates to:
  /// **'Baseline history'**
  String get baselineConfidence;

  /// No description provided for @sensorAvailability.
  ///
  /// In en, this message translates to:
  /// **'Sensor availability'**
  String get sensorAvailability;

  /// No description provided for @demoResetFull.
  ///
  /// In en, this message translates to:
  /// **'Reset demo to Normal Mode'**
  String get demoResetFull;

  /// No description provided for @demoSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'SIH flood demonstration'**
  String get demoSequenceTitle;

  /// No description provided for @demoStageComplete.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get demoStageComplete;

  /// No description provided for @demoStageCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current step'**
  String get demoStageCurrent;

  /// No description provided for @demoStage1Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 1. Normal Mode'**
  String get demoStage1Title;

  /// No description provided for @demoStage2Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 2. Official flood warning'**
  String get demoStage2Title;

  /// No description provided for @demoStage3Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 3. Disaster active'**
  String get demoStage3Title;

  /// No description provided for @demoStage4Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 4. Connectivity failure'**
  String get demoStage4Title;

  /// No description provided for @demoStage5Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 5. Survival Mode'**
  String get demoStage5Title;

  /// No description provided for @demoStage6Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 6. Fall and deterioration'**
  String get demoStage6Title;

  /// No description provided for @demoStage7Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 7. Emergency packet'**
  String get demoStage7Title;

  /// No description provided for @demoStage8Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 8. Connectivity restored'**
  String get demoStage8Title;

  /// No description provided for @demoStage9Title.
  ///
  /// In en, this message translates to:
  /// **'Stage 9. Rescue dashboard'**
  String get demoStage9Title;

  /// No description provided for @demoStage1Body.
  ///
  /// In en, this message translates to:
  /// **'Replay labeled normal readings. PRANA learns a personal baseline through the real inference pipeline.'**
  String get demoStage1Body;

  /// No description provided for @demoStage2Body.
  ///
  /// In en, this message translates to:
  /// **'Inject an official flood warning. PRANA moves from Normal to Disaster alert.'**
  String get demoStage2Body;

  /// No description provided for @demoStage3Body.
  ///
  /// In en, this message translates to:
  /// **'Confirm the disaster. Structured flood guidance is shown from the local catalog.'**
  String get demoStage3Body;

  /// No description provided for @demoStage4Body.
  ///
  /// In en, this message translates to:
  /// **'Simulate loss of internet and backend connectivity. Monitoring and guidance stay on this device.'**
  String get demoStage4Body;

  /// No description provided for @demoStage5Body.
  ///
  /// In en, this message translates to:
  /// **'The user is stranded. Survival Mode continues local monitoring without a cloud round trip.'**
  String get demoStage5Body;

  /// No description provided for @demoStage6Body.
  ///
  /// In en, this message translates to:
  /// **'Replay deterioration and fall sensor sequences. Fall detection still requires spike, impact, orientation, inactivity, and confirmation.'**
  String get demoStage6Body;

  /// No description provided for @demoStage7Body.
  ///
  /// In en, this message translates to:
  /// **'Create the emergency record through the application pipeline. It is stored locally and is not marked delivered.'**
  String get demoStage7Body;

  /// No description provided for @demoStage8Body.
  ///
  /// In en, this message translates to:
  /// **'Restore simulated connectivity. Store-and-forward moves the packet only after the transport confirms delivery.'**
  String get demoStage8Body;

  /// No description provided for @demoStage9Body.
  ///
  /// In en, this message translates to:
  /// **'Open the Rescue view of the same stored packet. This is not a separate fake object.'**
  String get demoStage9Body;

  /// No description provided for @demoNextStage.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get demoNextStage;

  /// No description provided for @demoPreviousStage.
  ///
  /// In en, this message translates to:
  /// **'Previous stage'**
  String get demoPreviousStage;

  /// No description provided for @demoAutoPlay.
  ///
  /// In en, this message translates to:
  /// **'Play remaining stages'**
  String get demoAutoPlay;

  /// No description provided for @demoStopAutoPlay.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get demoStopAutoPlay;

  /// No description provided for @demoStageProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String demoStageProgress(int current, int total);

  /// No description provided for @simulatedConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Connectivity shown here is simulated for the prototype.'**
  String get simulatedConnectivity;

  /// No description provided for @recentHealthEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent health events'**
  String get recentHealthEvents;

  /// No description provided for @noRecentHealthEvents.
  ///
  /// In en, this message translates to:
  /// **'No health events have been recorded in this session yet.'**
  String get noRecentHealthEvents;

  /// No description provided for @aboutAarogya.
  ///
  /// In en, this message translates to:
  /// **'About PRANA'**
  String get aboutAarogya;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersionLabel;

  /// No description provided for @appVersionValue.
  ///
  /// In en, this message translates to:
  /// **'0.1.0'**
  String get appVersionValue;

  /// No description provided for @presentationTarget.
  ///
  /// In en, this message translates to:
  /// **'The SIH presentation target is this browser demo. The long-term product remains a mobile companion.'**
  String get presentationTarget;

  /// No description provided for @medicalDisclaimerShort.
  ///
  /// In en, this message translates to:
  /// **'PRANA is a risk detection and emergency assistance system. It is not a medical diagnostic system.'**
  String get medicalDisclaimerShort;

  /// No description provided for @packetStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Stored locally'**
  String get packetStoredLocally;

  /// No description provided for @packetPendingDelivery.
  ///
  /// In en, this message translates to:
  /// **'Pending transmission'**
  String get packetPendingDelivery;

  /// No description provided for @packetDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get packetDelivered;

  /// No description provided for @openRescueDashboard.
  ///
  /// In en, this message translates to:
  /// **'Open rescue dashboard'**
  String get openRescueDashboard;

  /// No description provided for @rescueEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No emergency packet is stored yet. Use the demonstration to generate one through the application pipeline.'**
  String get rescueEmptyHint;

  /// No description provided for @demoSessionState.
  ///
  /// In en, this message translates to:
  /// **'Current session'**
  String get demoSessionState;

  /// No description provided for @webPresentationHint.
  ///
  /// In en, this message translates to:
  /// **'Each step injects data or an official event into the real PRANA pipeline.'**
  String get webPresentationHint;

  /// No description provided for @simulationData.
  ///
  /// In en, this message translates to:
  /// **'Demonstration data'**
  String get simulationData;

  /// No description provided for @simulationNotice.
  ///
  /// In en, this message translates to:
  /// **'These readings are labeled demonstration data and are not clinical evidence.'**
  String get simulationNotice;

  /// No description provided for @demoTitle.
  ///
  /// In en, this message translates to:
  /// **'Demonstration controls'**
  String get demoTitle;

  /// No description provided for @demoReplayNormal.
  ///
  /// In en, this message translates to:
  /// **'Replay normal baseline dataset'**
  String get demoReplayNormal;

  /// No description provided for @demoFloodWarning.
  ///
  /// In en, this message translates to:
  /// **'Inject official flood warning'**
  String get demoFloodWarning;

  /// No description provided for @demoConfirmDisaster.
  ///
  /// In en, this message translates to:
  /// **'Confirm disaster active'**
  String get demoConfirmDisaster;

  /// No description provided for @demoReplayFlood.
  ///
  /// In en, this message translates to:
  /// **'Replay flood exertion dataset'**
  String get demoReplayFlood;

  /// No description provided for @demoGoOffline.
  ///
  /// In en, this message translates to:
  /// **'Set connectivity offline'**
  String get demoGoOffline;

  /// No description provided for @demoEnterSurvival.
  ///
  /// In en, this message translates to:
  /// **'Enter survival mode'**
  String get demoEnterSurvival;

  /// No description provided for @demoReplayDeterioration.
  ///
  /// In en, this message translates to:
  /// **'Replay physiological deterioration'**
  String get demoReplayDeterioration;

  /// No description provided for @demoReplayFall.
  ///
  /// In en, this message translates to:
  /// **'Replay fall sequence'**
  String get demoReplayFall;

  /// No description provided for @demoRestoreConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Restore connectivity'**
  String get demoRestoreConnectivity;

  /// No description provided for @demoEscalateFall.
  ///
  /// In en, this message translates to:
  /// **'Escalate unconfirmed fall'**
  String get demoEscalateFall;

  /// No description provided for @demoResolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve emergency'**
  String get demoResolve;

  /// No description provided for @demoReset.
  ///
  /// In en, this message translates to:
  /// **'Return to normal'**
  String get demoReset;

  /// No description provided for @rescueDashboard.
  ///
  /// In en, this message translates to:
  /// **'Emergency Response'**
  String get rescueDashboard;

  /// No description provided for @noEmergencyPackets.
  ///
  /// In en, this message translates to:
  /// **'No emergency packets have been stored or received.'**
  String get noEmergencyPackets;

  /// No description provided for @packetState.
  ///
  /// In en, this message translates to:
  /// **'Packet state'**
  String get packetState;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get eventType;

  /// No description provided for @eventId.
  ///
  /// In en, this message translates to:
  /// **'Event identifier'**
  String get eventId;

  /// No description provided for @eventTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get eventTimestamp;

  /// No description provided for @communicationStatus.
  ///
  /// In en, this message translates to:
  /// **'Communication status'**
  String get communicationStatus;

  /// No description provided for @deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get deviceId;

  /// No description provided for @whatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get whatHappened;

  /// No description provided for @howSerious.
  ///
  /// In en, this message translates to:
  /// **'How serious'**
  String get howSerious;

  /// No description provided for @whatToDo.
  ///
  /// In en, this message translates to:
  /// **'What you should do'**
  String get whatToDo;

  /// No description provided for @movementNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get movementNone;

  /// No description provided for @movementLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get movementLow;

  /// No description provided for @movementNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get movementNormal;

  /// No description provided for @movementHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get movementHigh;

  /// No description provided for @movementIrregular.
  ///
  /// In en, this message translates to:
  /// **'Irregular'**
  String get movementIrregular;

  /// No description provided for @reasonHrAboveBaseline.
  ///
  /// In en, this message translates to:
  /// **'Heart rate is significantly above your usual baseline.'**
  String get reasonHrAboveBaseline;

  /// No description provided for @reasonSpo2BelowBaseline.
  ///
  /// In en, this message translates to:
  /// **'SpO2 has decreased from your recent baseline.'**
  String get reasonSpo2BelowBaseline;

  /// No description provided for @reasonProlongedActivity.
  ///
  /// In en, this message translates to:
  /// **'Prolonged physical activity detected.'**
  String get reasonProlongedActivity;

  /// No description provided for @reasonHighHrLowMovement.
  ///
  /// In en, this message translates to:
  /// **'Heart rate is elevated while movement is low.'**
  String get reasonHighHrLowMovement;

  /// No description provided for @reasonEnvironmentalStress.
  ///
  /// In en, this message translates to:
  /// **'Disaster conditions increase the significance of current readings.'**
  String get reasonEnvironmentalStress;

  /// No description provided for @reasonLimitedSensors.
  ///
  /// In en, this message translates to:
  /// **'Some sensors are unavailable. Risk is based on remaining signals.'**
  String get reasonLimitedSensors;

  /// No description provided for @reasonInsufficientHistory.
  ///
  /// In en, this message translates to:
  /// **'There is not enough personal history to score risk yet.'**
  String get reasonInsufficientHistory;

  /// No description provided for @reasonPossibleFall.
  ///
  /// In en, this message translates to:
  /// **'A possible fall sequence was detected.'**
  String get reasonPossibleFall;

  /// No description provided for @reasonModelExertion.
  ///
  /// In en, this message translates to:
  /// **'Heart-rate change is being interpreted with physical activity in mind.'**
  String get reasonModelExertion;

  /// No description provided for @reasonModelElevatedLoad.
  ///
  /// In en, this message translates to:
  /// **'Your readings differ from your usual rest pattern.'**
  String get reasonModelElevatedLoad;

  /// No description provided for @readingsDifferFromBaseline.
  ///
  /// In en, this message translates to:
  /// **'Your current readings differ significantly from your usual baseline.'**
  String get readingsDifferFromBaseline;

  /// No description provided for @elevatedHealthRisk.
  ///
  /// In en, this message translates to:
  /// **'Elevated health risk detected.'**
  String get elevatedHealthRisk;

  /// No description provided for @emergencyEventRecorded.
  ///
  /// In en, this message translates to:
  /// **'Emergency event recorded.'**
  String get emergencyEventRecorded;

  /// No description provided for @engineVersion.
  ///
  /// In en, this message translates to:
  /// **'Engine version'**
  String get engineVersion;

  /// No description provided for @homeGuidanceNormal.
  ///
  /// In en, this message translates to:
  /// **'Continue routine monitoring. PRANA stays on this device.'**
  String get homeGuidanceNormal;

  /// No description provided for @continueUsing.
  ///
  /// In en, this message translates to:
  /// **'Continue using PRANA.'**
  String get continueUsing;

  /// No description provided for @disasterType.
  ///
  /// In en, this message translates to:
  /// **'Disaster type'**
  String get disasterType;

  /// No description provided for @activationSource.
  ///
  /// In en, this message translates to:
  /// **'Activation source'**
  String get activationSource;

  /// No description provided for @userActivation.
  ///
  /// In en, this message translates to:
  /// **'User activation'**
  String get userActivation;

  /// No description provided for @localDetection.
  ///
  /// In en, this message translates to:
  /// **'Supported local detection'**
  String get localDetection;

  /// No description provided for @productTagline.
  ///
  /// In en, this message translates to:
  /// **'Personal Health & Emergency Assistance'**
  String get productTagline;

  /// No description provided for @startDisasterDemo.
  ///
  /// In en, this message translates to:
  /// **'Start disaster demo'**
  String get startDisasterDemo;

  /// No description provided for @simulationBadge.
  ///
  /// In en, this message translates to:
  /// **'Demonstration data'**
  String get simulationBadge;

  /// No description provided for @stageHeroLabel.
  ///
  /// In en, this message translates to:
  /// **'STAGE {number}'**
  String stageHeroLabel(String number);

  /// No description provided for @stageShort1.
  ///
  /// In en, this message translates to:
  /// **'Your health'**
  String get stageShort1;

  /// No description provided for @stageShort2.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get stageShort2;

  /// No description provided for @stageShort3.
  ///
  /// In en, this message translates to:
  /// **'Safer place'**
  String get stageShort3;

  /// No description provided for @stageShort4.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get stageShort4;

  /// No description provided for @stageShort5.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get stageShort5;

  /// No description provided for @stageShort6.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get stageShort6;

  /// No description provided for @stageShort7.
  ///
  /// In en, this message translates to:
  /// **'Emergency Packet'**
  String get stageShort7;

  /// No description provided for @stageShort8.
  ///
  /// In en, this message translates to:
  /// **'Communication Restored'**
  String get stageShort8;

  /// No description provided for @stageShort9.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get stageShort9;

  /// No description provided for @demoStage1Hero.
  ///
  /// In en, this message translates to:
  /// **'Your health'**
  String get demoStage1Hero;

  /// No description provided for @demoStage1HeroBody.
  ///
  /// In en, this message translates to:
  /// **'Review your usual readings and the current health assessment.'**
  String get demoStage1HeroBody;

  /// No description provided for @demoStage2Hero.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get demoStage2Hero;

  /// No description provided for @demoStage2HeroBody.
  ///
  /// In en, this message translates to:
  /// **'An official flood warning is now active. Follow the guidance on this screen.'**
  String get demoStage2HeroBody;

  /// No description provided for @demoStage3Hero.
  ///
  /// In en, this message translates to:
  /// **'Safer location'**
  String get demoStage3Hero;

  /// No description provided for @demoStage3HeroBody.
  ///
  /// In en, this message translates to:
  /// **'A recommended safer place is shown with the reason it was chosen.'**
  String get demoStage3HeroBody;

  /// No description provided for @demoStage4Hero.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get demoStage4Hero;

  /// No description provided for @demoStage4HeroBody.
  ///
  /// In en, this message translates to:
  /// **'A possible fall was detected. Confirm whether you need help.'**
  String get demoStage4HeroBody;

  /// No description provided for @demoStage5Hero.
  ///
  /// In en, this message translates to:
  /// **'Nearby PRANA users'**
  String get demoStage5Hero;

  /// No description provided for @demoStage5HeroBody.
  ///
  /// In en, this message translates to:
  /// **'Receive or forward emergency information with nearby PRANA users.'**
  String get demoStage5HeroBody;

  /// No description provided for @demoStage6Hero.
  ///
  /// In en, this message translates to:
  /// **'Emergency response'**
  String get demoStage6Hero;

  /// No description provided for @demoStage6HeroBody.
  ///
  /// In en, this message translates to:
  /// **'Open the responder view of the same emergency record.'**
  String get demoStage6HeroBody;

  /// No description provided for @demoStage7Hero.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY PACKET'**
  String get demoStage7Hero;

  /// No description provided for @demoStage7HeroBody.
  ///
  /// In en, this message translates to:
  /// **'The emergency record is stored on this device until a communication path is available.'**
  String get demoStage7HeroBody;

  /// No description provided for @demoStage8Hero.
  ///
  /// In en, this message translates to:
  /// **'COMMUNICATION RESTORED'**
  String get demoStage8Hero;

  /// No description provided for @demoStage8HeroBody.
  ///
  /// In en, this message translates to:
  /// **'Simulated connectivity has returned. The packet moves only after the transport confirms delivery.'**
  String get demoStage8HeroBody;

  /// No description provided for @demoStage9Hero.
  ///
  /// In en, this message translates to:
  /// **'RESCUE DASHBOARD'**
  String get demoStage9Hero;

  /// No description provided for @demoStage9HeroBody.
  ///
  /// In en, this message translates to:
  /// **'Rescue view shows the same stored emergency packet generated by the demonstration.'**
  String get demoStage9HeroBody;

  /// No description provided for @modeChipNormal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get modeChipNormal;

  /// No description provided for @modeChipDisasterAlert.
  ///
  /// In en, this message translates to:
  /// **'DISASTER ALERT'**
  String get modeChipDisasterAlert;

  /// No description provided for @modeChipDisasterActive.
  ///
  /// In en, this message translates to:
  /// **'DISASTER ACTIVE'**
  String get modeChipDisasterActive;

  /// No description provided for @modeChipSurvival.
  ///
  /// In en, this message translates to:
  /// **'SURVIVAL'**
  String get modeChipSurvival;

  /// No description provided for @modeChipEmergency.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get modeChipEmergency;

  /// No description provided for @modeChipResolved.
  ///
  /// In en, this message translates to:
  /// **'RESOLVED'**
  String get modeChipResolved;

  /// No description provided for @capabilityLocalMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Local monitoring'**
  String get capabilityLocalMonitoring;

  /// No description provided for @capabilityLocalInference.
  ///
  /// In en, this message translates to:
  /// **'Local assessment'**
  String get capabilityLocalInference;

  /// No description provided for @capabilityLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get capabilityLocalStorage;

  /// No description provided for @capabilityDisasterGuidance.
  ///
  /// In en, this message translates to:
  /// **'Disaster guidance'**
  String get capabilityDisasterGuidance;

  /// No description provided for @capabilityEmergencyProcessing.
  ///
  /// In en, this message translates to:
  /// **'Emergency processing'**
  String get capabilityEmergencyProcessing;

  /// No description provided for @capabilityActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get capabilityActive;

  /// No description provided for @capabilityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get capabilityAvailable;

  /// No description provided for @networkLabel.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get networkLabel;

  /// No description provided for @fallStepSpike.
  ///
  /// In en, this message translates to:
  /// **'Movement spike'**
  String get fallStepSpike;

  /// No description provided for @fallStepImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact detected'**
  String get fallStepImpact;

  /// No description provided for @fallStepOrientation.
  ///
  /// In en, this message translates to:
  /// **'Orientation change'**
  String get fallStepOrientation;

  /// No description provided for @fallStepInactivity.
  ///
  /// In en, this message translates to:
  /// **'Inactivity detected'**
  String get fallStepInactivity;

  /// No description provided for @fallStepConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation window'**
  String get fallStepConfirmation;

  /// No description provided for @fallStepEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency event confirmed'**
  String get fallStepEmergency;

  /// No description provided for @packetLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Local only'**
  String get packetLocalOnly;

  /// No description provided for @packetPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get packetPending;

  /// No description provided for @packetSentDelivered.
  ///
  /// In en, this message translates to:
  /// **'Sent / Delivered'**
  String get packetSentDelivered;

  /// No description provided for @affectedArea.
  ///
  /// In en, this message translates to:
  /// **'Affected area'**
  String get affectedArea;

  /// No description provided for @demoLocationKathmandu.
  ///
  /// In en, this message translates to:
  /// **'Kathmandu valley demonstration area'**
  String get demoLocationKathmandu;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidenceLabel;

  /// No description provided for @inferenceSource.
  ///
  /// In en, this message translates to:
  /// **'Inference source'**
  String get inferenceSource;

  /// No description provided for @inferenceTrainedModel.
  ///
  /// In en, this message translates to:
  /// **'On-device trained model'**
  String get inferenceTrainedModel;

  /// No description provided for @inferenceRulesOnly.
  ///
  /// In en, this message translates to:
  /// **'Baseline rules only'**
  String get inferenceRulesOnly;

  /// No description provided for @physioContext.
  ///
  /// In en, this message translates to:
  /// **'Physiological context'**
  String get physioContext;

  /// No description provided for @physioContextRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get physioContextRest;

  /// No description provided for @physioContextExertion.
  ///
  /// In en, this message translates to:
  /// **'Exertion'**
  String get physioContextExertion;

  /// No description provided for @physioContextElevatedLoad.
  ///
  /// In en, this message translates to:
  /// **'Elevated load'**
  String get physioContextElevatedLoad;

  /// No description provided for @modelConfidence.
  ///
  /// In en, this message translates to:
  /// **'Model confidence'**
  String get modelConfidence;

  /// No description provided for @researchRecording.
  ///
  /// In en, this message translates to:
  /// **'Research recording'**
  String get researchRecording;

  /// No description provided for @riskScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk score'**
  String get riskScoreLabel;

  /// No description provided for @sensorSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sensor source'**
  String get sensorSourceLabel;

  /// No description provided for @sensorSourceSimulation.
  ///
  /// In en, this message translates to:
  /// **'Demonstration data'**
  String get sensorSourceSimulation;

  /// No description provided for @sensorSourceDataset.
  ///
  /// In en, this message translates to:
  /// **'Research recording'**
  String get sensorSourceDataset;

  /// No description provided for @sensorSourceWearable.
  ///
  /// In en, this message translates to:
  /// **'Wearable'**
  String get sensorSourceWearable;

  /// No description provided for @recentHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Recent heart rate'**
  String get recentHeartRate;

  /// No description provided for @heartRateNowUsual.
  ///
  /// In en, this message translates to:
  /// **'Heart rate now / usual'**
  String get heartRateNowUsual;

  /// No description provided for @spo2NowUsual.
  ///
  /// In en, this message translates to:
  /// **'SpO2 now / usual'**
  String get spo2NowUsual;

  /// No description provided for @windowHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Recent window heart rate'**
  String get windowHeartRate;

  /// No description provided for @riskInputs.
  ///
  /// In en, this message translates to:
  /// **'Risk inputs'**
  String get riskInputs;

  /// No description provided for @riskInputsValue.
  ///
  /// In en, this message translates to:
  /// **'Rules {rules} · trained context {model}'**
  String riskInputsValue(String rules, String model);

  /// No description provided for @fallCheck.
  ///
  /// In en, this message translates to:
  /// **'Fall check'**
  String get fallCheck;

  /// No description provided for @fallCheckSimulated.
  ///
  /// In en, this message translates to:
  /// **'Fall detection: demonstration mode'**
  String get fallCheckSimulated;

  /// No description provided for @assessmentWhyHeading.
  ///
  /// In en, this message translates to:
  /// **'Why this assessment'**
  String get assessmentWhyHeading;

  /// No description provided for @alertHrVsBaseline.
  ///
  /// In en, this message translates to:
  /// **'Heart rate is {current} BPM compared with usual rest {usual} BPM.'**
  String alertHrVsBaseline(String current, String usual);

  /// No description provided for @alertSpo2VsBaseline.
  ///
  /// In en, this message translates to:
  /// **'SpO2 is {current}% compared with usual {usual}%.'**
  String alertSpo2VsBaseline(String current, String usual);

  /// No description provided for @alertModelDetected.
  ///
  /// In en, this message translates to:
  /// **'Health assessment: {context} ({confidence}% confidence).'**
  String alertModelDetected(String context, String confidence);

  /// No description provided for @alertRiskCombined.
  ///
  /// In en, this message translates to:
  /// **'Risk increased from current measurements and your personal baseline.'**
  String get alertRiskCombined;

  /// No description provided for @modelPipelineNote.
  ///
  /// In en, this message translates to:
  /// **'Assessment based on your recent readings and personal baseline.'**
  String get modelPipelineNote;

  /// No description provided for @usualRestHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Usual rest heart rate'**
  String get usualRestHeartRate;

  /// No description provided for @usualRestSpo2.
  ///
  /// In en, this message translates to:
  /// **'Usual rest SpO2'**
  String get usualRestSpo2;

  /// No description provided for @fallDetectionMode.
  ///
  /// In en, this message translates to:
  /// **'Fall detection'**
  String get fallDetectionMode;

  /// No description provided for @fallDetectionSimulated.
  ///
  /// In en, this message translates to:
  /// **'Demonstration mode'**
  String get fallDetectionSimulated;

  /// No description provided for @yourHealth.
  ///
  /// In en, this message translates to:
  /// **'Your Health'**
  String get yourHealth;

  /// No description provided for @emergencyInformation.
  ///
  /// In en, this message translates to:
  /// **'Emergency Information'**
  String get emergencyInformation;

  /// No description provided for @emergencyAssistance.
  ///
  /// In en, this message translates to:
  /// **'Emergency Assistance'**
  String get emergencyAssistance;

  /// No description provided for @emergencyResponse.
  ///
  /// In en, this message translates to:
  /// **'Emergency Response'**
  String get emergencyResponse;

  /// No description provided for @healthAssessment.
  ///
  /// In en, this message translates to:
  /// **'Health assessment'**
  String get healthAssessment;

  /// No description provided for @assessmentConfidence.
  ///
  /// In en, this message translates to:
  /// **'Assessment confidence'**
  String get assessmentConfidence;

  /// No description provided for @assessmentFromReadings.
  ///
  /// In en, this message translates to:
  /// **'Assessment based on your recent readings and personal baseline.'**
  String get assessmentFromReadings;

  /// No description provided for @demonstrationData.
  ///
  /// In en, this message translates to:
  /// **'Demonstration data'**
  String get demonstrationData;

  /// No description provided for @technicalInformation.
  ///
  /// In en, this message translates to:
  /// **'Technical information'**
  String get technicalInformation;

  /// No description provided for @technicalInformationHint.
  ///
  /// In en, this message translates to:
  /// **'For evaluation only. These details are not shown in the public health screens.'**
  String get technicalInformationHint;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @needAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Register'**
  String get needAccount;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;

  /// No description provided for @sessionPersistsHint.
  ///
  /// In en, this message translates to:
  /// **'Your account stays signed in on this device until you sign out.'**
  String get sessionPersistsHint;

  /// No description provided for @dataStaysOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Health assessment stays on this device. Signed-in sync stores only the records needed for your account.'**
  String get dataStaysOnDevice;

  /// No description provided for @authRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in to use PRANA on this device.'**
  String get authRequiredHint;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use a password with at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'That email or password could not be verified.'**
  String get invalidCredentials;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'The account could not be created. Try a different email.'**
  String get registrationFailed;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailRequired;

  /// No description provided for @deviceIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Device identifier'**
  String get deviceIdentifier;

  /// No description provided for @userIdentifier.
  ///
  /// In en, this message translates to:
  /// **'User identifier'**
  String get userIdentifier;

  /// No description provided for @peerNetworkNotActive.
  ///
  /// In en, this message translates to:
  /// **'Nearby sharing uses a same-origin browser demonstration relay stored on this device. It is not Bluetooth or mesh radio.'**
  String get peerNetworkNotActive;

  /// No description provided for @publicLandingBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your baseline and emergency information on this account.'**
  String get publicLandingBody;

  /// No description provided for @syncWhenConnected.
  ///
  /// In en, this message translates to:
  /// **'Emergency information is stored on this device first, then synchronized when connectivity is available.'**
  String get syncWhenConnected;

  /// No description provided for @emailOrMobile.
  ///
  /// In en, this message translates to:
  /// **'Email / Mobile'**
  String get emailOrMobile;

  /// No description provided for @identifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address or mobile number.'**
  String get identifierRequired;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @continueAsDemoUser.
  ///
  /// In en, this message translates to:
  /// **'Continue as demonstration user'**
  String get continueAsDemoUser;

  /// No description provided for @demoAccountHint.
  ///
  /// In en, this message translates to:
  /// **'This opens a demonstration account. It still uses the same health and emergency pipeline, and it stays separate from personal accounts.'**
  String get demoAccountHint;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @accountNav.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountNav;

  /// No description provided for @accountIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountIdentifier;

  /// No description provided for @healthDataStatus.
  ///
  /// In en, this message translates to:
  /// **'Health data'**
  String get healthDataStatus;

  /// No description provided for @emergencyRecords.
  ///
  /// In en, this message translates to:
  /// **'Emergency records'**
  String get emergencyRecords;

  /// No description provided for @demonstrationAccount.
  ///
  /// In en, this message translates to:
  /// **'Demonstration account'**
  String get demonstrationAccount;

  /// No description provided for @baselineReadyShort.
  ///
  /// In en, this message translates to:
  /// **'Personal baseline established'**
  String get baselineReadyShort;

  /// No description provided for @baselineNotReadyShort.
  ///
  /// In en, this message translates to:
  /// **'Personal baseline not established yet'**
  String get baselineNotReadyShort;

  /// No description provided for @readingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stored readings'**
  String readingCount(int count);

  /// No description provided for @packetCount.
  ///
  /// In en, this message translates to:
  /// **'{count} emergency records'**
  String packetCount(int count);

  /// No description provided for @duplicateAccount.
  ///
  /// In en, this message translates to:
  /// **'An account with that email or mobile number already exists.'**
  String get duplicateAccount;

  /// No description provided for @sensorSourceDevice.
  ///
  /// In en, this message translates to:
  /// **'Connected device'**
  String get sensorSourceDevice;

  /// No description provided for @nearbyAarogyaUsers.
  ///
  /// In en, this message translates to:
  /// **'Nearby PRANA users'**
  String get nearbyAarogyaUsers;

  /// No description provided for @nearbyRelayHint.
  ///
  /// In en, this message translates to:
  /// **'Nearby sharing on this device is a browser demonstration. It is not Bluetooth or mesh radio.'**
  String get nearbyRelayHint;

  /// No description provided for @noNearbyUsers.
  ///
  /// In en, this message translates to:
  /// **'No other signed-in PRANA sessions are sharing nearby right now.'**
  String get noNearbyUsers;

  /// No description provided for @forwardEmergency.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forwardEmergency;

  /// No description provided for @forwardedNearby.
  ///
  /// In en, this message translates to:
  /// **'Forwarded to nearby PRANA users'**
  String get forwardedNearby;

  /// No description provided for @connectedDevice.
  ///
  /// In en, this message translates to:
  /// **'Connected device'**
  String get connectedDevice;

  /// No description provided for @connectHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Connect heart-rate monitor'**
  String get connectHeartRate;

  /// No description provided for @heartRateBrowserOnly.
  ///
  /// In en, this message translates to:
  /// **'Heart-rate connection is available in browsers that support Bluetooth accessories. This is not Apple Watch or Fitbit pairing.'**
  String get heartRateBrowserOnly;

  /// No description provided for @heartRateUnavailableBrowser.
  ///
  /// In en, this message translates to:
  /// **'Heart-rate accessory connection is not available in this browser.'**
  String get heartRateUnavailableBrowser;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @demonstrationLocation.
  ///
  /// In en, this message translates to:
  /// **'Demonstration location'**
  String get demonstrationLocation;

  /// No description provided for @gpsLocation.
  ///
  /// In en, this message translates to:
  /// **'Device location'**
  String get gpsLocation;

  /// No description provided for @requestLocation.
  ///
  /// In en, this message translates to:
  /// **'Use device location'**
  String get requestLocation;

  /// No description provided for @saferLocation.
  ///
  /// In en, this message translates to:
  /// **'Safer location'**
  String get saferLocation;

  /// No description provided for @saferLocationRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended based on available emergency and geographic information.'**
  String get saferLocationRecommended;

  /// No description provided for @notDefinitelySafe.
  ///
  /// In en, this message translates to:
  /// **'This does not mean the location is definitely safe.'**
  String get notDefinitelySafe;

  /// No description provided for @directionAndDistance.
  ///
  /// In en, this message translates to:
  /// **'Direction and distance from available coordinates. Not turn-by-turn street navigation.'**
  String get directionAndDistance;

  /// No description provided for @mapTilesNeedNetwork.
  ///
  /// In en, this message translates to:
  /// **'Map tiles need a network connection. Distance and direction still work from saved geographic information.'**
  String get mapTilesNeedNetwork;

  /// No description provided for @osmAttribution.
  ///
  /// In en, this message translates to:
  /// **'Map tiles © OpenStreetMap contributors'**
  String get osmAttribution;

  /// No description provided for @distanceAndBearing.
  ///
  /// In en, this message translates to:
  /// **'{distance} m {direction}'**
  String distanceAndBearing(String distance, String direction);

  /// No description provided for @insideHazardArea.
  ///
  /// In en, this message translates to:
  /// **'You are inside a demonstration hazard area.'**
  String get insideHazardArea;

  /// No description provided for @fallCheckOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Fall check: on-device assessment'**
  String get fallCheckOnDevice;

  /// No description provided for @receivedNearby.
  ///
  /// In en, this message translates to:
  /// **'Received nearby'**
  String get receivedNearby;

  /// No description provided for @thisAccountEmergency.
  ///
  /// In en, this message translates to:
  /// **'This account'**
  String get thisAccountEmergency;

  /// No description provided for @eventTypePossibleFall.
  ///
  /// In en, this message translates to:
  /// **'Possible fall'**
  String get eventTypePossibleFall;

  /// No description provided for @eventTypeDeterioration.
  ///
  /// In en, this message translates to:
  /// **'Elevated health risk'**
  String get eventTypeDeterioration;

  /// No description provided for @fromUser.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String fromUser(String name);

  /// No description provided for @nearbyRelayTechnical.
  ///
  /// In en, this message translates to:
  /// **'Nearby sharing uses a same-origin browser demonstration relay (not Bluetooth).'**
  String get nearbyRelayTechnical;

  /// No description provided for @inMemoryTransportTechnical.
  ///
  /// In en, this message translates to:
  /// **'In-memory demonstration transport (tests).'**
  String get inMemoryTransportTechnical;

  /// No description provided for @accelAvailable.
  ///
  /// In en, this message translates to:
  /// **'Movement sensors'**
  String get accelAvailable;

  /// No description provided for @gyroAvailable.
  ///
  /// In en, this message translates to:
  /// **'Rotation sensors'**
  String get gyroAvailable;

  /// No description provided for @availableShort.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableShort;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @iNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'I need help'**
  String get iNeedHelp;

  /// No description provided for @fallCheckCancelled.
  ///
  /// In en, this message translates to:
  /// **'Fall check cancelled. No emergency packet was created.'**
  String get fallCheckCancelled;

  /// No description provided for @receiveEmergency.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receiveEmergency;

  /// No description provided for @emergencyInformationAvailable.
  ///
  /// In en, this message translates to:
  /// **'Emergency information available'**
  String get emergencyInformationAvailable;

  /// No description provided for @nearbySharingHint.
  ///
  /// In en, this message translates to:
  /// **'Nearby sharing on this device is a browser demonstration. It is not Bluetooth or mesh radio.'**
  String get nearbySharingHint;

  /// No description provided for @noNearbySaferLocation.
  ///
  /// In en, this message translates to:
  /// **'No nearby safer location identified.'**
  String get noNearbySaferLocation;

  /// No description provided for @recommendedSaferLocation.
  ///
  /// In en, this message translates to:
  /// **'Recommended safer location'**
  String get recommendedSaferLocation;

  /// No description provided for @directionToSaferLocation.
  ///
  /// In en, this message translates to:
  /// **'Direction to safer location'**
  String get directionToSaferLocation;

  /// No description provided for @demonstrationAreaKathmandu.
  ///
  /// In en, this message translates to:
  /// **'Kathmandu flood area'**
  String get demonstrationAreaKathmandu;

  /// No description provided for @demonstrationAreaDelhi.
  ///
  /// In en, this message translates to:
  /// **'Delhi area'**
  String get demonstrationAreaDelhi;

  /// No description provided for @locationOutsideDemonstration.
  ///
  /// In en, this message translates to:
  /// **'Device location is outside the configured demonstration areas. The current demonstration area is unchanged.'**
  String get locationOutsideDemonstration;

  /// No description provided for @replayDemonstrationReadings.
  ///
  /// In en, this message translates to:
  /// **'Replay demonstration readings'**
  String get replayDemonstrationReadings;

  /// No description provided for @currentSituation.
  ///
  /// In en, this message translates to:
  /// **'Current situation'**
  String get currentSituation;

  /// No description provided for @currentCondition.
  ///
  /// In en, this message translates to:
  /// **'Current condition'**
  String get currentCondition;

  /// No description provided for @recommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended action'**
  String get recommendedAction;

  /// No description provided for @assistanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Assistance status'**
  String get assistanceStatus;

  /// No description provided for @myEmergencyInformation.
  ///
  /// In en, this message translates to:
  /// **'My emergency information'**
  String get myEmergencyInformation;

  /// No description provided for @selectSaferLocation.
  ///
  /// In en, this message translates to:
  /// **'Select a safer location'**
  String get selectSaferLocation;

  /// No description provided for @bloodOxygen.
  ///
  /// In en, this message translates to:
  /// **'Blood oxygen'**
  String get bloodOxygen;

  /// No description provided for @limitedConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Limited connectivity'**
  String get limitedConnectivity;

  /// No description provided for @situationNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get situationNormal;

  /// No description provided for @situationEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get situationEmergency;

  /// No description provided for @personLabel.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get personLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @healthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health summary'**
  String get healthSummary;

  /// No description provided for @pranaTaglineFull.
  ///
  /// In en, this message translates to:
  /// **'Privacy-preserving Resilience & Adaptive Neural Assistant'**
  String get pranaTaglineFull;

  /// No description provided for @useDeviceLocation.
  ///
  /// In en, this message translates to:
  /// **'Use device location'**
  String get useDeviceLocation;

  /// No description provided for @demonstrationConditions.
  ///
  /// In en, this message translates to:
  /// **'Demonstration conditions'**
  String get demonstrationConditions;

  /// No description provided for @conditionResting.
  ///
  /// In en, this message translates to:
  /// **'Resting'**
  String get conditionResting;

  /// No description provided for @conditionPhysicalActivity.
  ///
  /// In en, this message translates to:
  /// **'Physical activity'**
  String get conditionPhysicalActivity;

  /// No description provided for @conditionHighLoad.
  ///
  /// In en, this message translates to:
  /// **'High load'**
  String get conditionHighLoad;

  /// No description provided for @conditionFallImpact.
  ///
  /// In en, this message translates to:
  /// **'Fall / impact'**
  String get conditionFallImpact;

  /// No description provided for @whyRecommended.
  ///
  /// In en, this message translates to:
  /// **'Why this place is recommended'**
  String get whyRecommended;

  /// No description provided for @mapLegendYou.
  ///
  /// In en, this message translates to:
  /// **'You are here'**
  String get mapLegendYou;

  /// No description provided for @mapLegendAffected.
  ///
  /// In en, this message translates to:
  /// **'Affected area'**
  String get mapLegendAffected;

  /// No description provided for @mapLegendSafer.
  ///
  /// In en, this message translates to:
  /// **'Recommended safer location'**
  String get mapLegendSafer;

  /// No description provided for @reasonOutsideHazard.
  ///
  /// In en, this message translates to:
  /// **'This place is outside the affected area.'**
  String get reasonOutsideHazard;

  /// No description provided for @reasonOpenSpace.
  ///
  /// In en, this message translates to:
  /// **'This is an open space.'**
  String get reasonOpenSpace;

  /// No description provided for @reasonNearestInRegion.
  ///
  /// In en, this message translates to:
  /// **'This is the nearest suitable place in this area.'**
  String get reasonNearestInRegion;

  /// No description provided for @reasonUnderGuidanceLimit.
  ///
  /// In en, this message translates to:
  /// **'It is within the local 15 km guidance range.'**
  String get reasonUnderGuidanceLimit;

  /// No description provided for @howItReachedUs.
  ///
  /// In en, this message translates to:
  /// **'How it reached us'**
  String get howItReachedUs;

  /// No description provided for @reachedFromThisAccount.
  ///
  /// In en, this message translates to:
  /// **'Recorded on this account.'**
  String get reachedFromThisAccount;

  /// No description provided for @reachedFromNearbyUser.
  ///
  /// In en, this message translates to:
  /// **'Received from a nearby PRANA user.'**
  String get reachedFromNearbyUser;

  /// No description provided for @urgencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgencyLabel;

  /// No description provided for @pranaAssistant.
  ///
  /// In en, this message translates to:
  /// **'PRANA Assistant'**
  String get pranaAssistant;

  /// No description provided for @assistantHowCanIHelp.
  ///
  /// In en, this message translates to:
  /// **'How can I help?'**
  String get assistantHowCanIHelp;

  /// No description provided for @assistantAskHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about this session'**
  String get assistantAskHint;

  /// No description provided for @assistantAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get assistantAsk;

  /// No description provided for @assistantUnrecognized.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have enough information to answer that from your current PRANA data.'**
  String get assistantUnrecognized;

  /// No description provided for @assistantInsufficient.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have enough information to answer that from your current PRANA data.'**
  String get assistantInsufficient;

  /// No description provided for @assistantCanHelpWith.
  ///
  /// In en, this message translates to:
  /// **'I can explain your current readings, usual pattern, safer location, and emergency guidance.'**
  String get assistantCanHelpWith;

  /// No description provided for @assistantReadingsClose.
  ///
  /// In en, this message translates to:
  /// **'Your recent readings are close to your usual pattern. No significant change from your current baseline has been identified.'**
  String get assistantReadingsClose;

  /// No description provided for @assistantRestAndRecheck.
  ///
  /// In en, this message translates to:
  /// **'If you have recently been active, rest for a few minutes and check again.'**
  String get assistantRestAndRecheck;

  /// No description provided for @assistantFallExplain.
  ///
  /// In en, this message translates to:
  /// **'PRANA detected a movement pattern that may indicate a fall. Please confirm that you are safe.'**
  String get assistantFallExplain;

  /// No description provided for @assistantEmergencyAttention.
  ///
  /// In en, this message translates to:
  /// **'Your current situation requires attention. PRANA has your emergency information and current location available. Follow the recommended safety guidance.'**
  String get assistantEmergencyAttention;

  /// No description provided for @assistantOfflineLocal.
  ///
  /// In en, this message translates to:
  /// **'Local monitoring, health assessment, saved guidance, and emergency records still work on this device. Forwarding waits until a connection is available.'**
  String get assistantOfflineLocal;

  /// No description provided for @assistantNoSaferPlace.
  ///
  /// In en, this message translates to:
  /// **'I don\'t currently have a suitable safer location available.'**
  String get assistantNoSaferPlace;

  /// No description provided for @assistantSaferPlaceApprox.
  ///
  /// In en, this message translates to:
  /// **'A recommended safer location is {place}, approximately {meters} metres {direction} of your current location.'**
  String assistantSaferPlaceApprox(
    String place,
    String meters,
    String direction,
  );

  /// No description provided for @assistantUsualHr.
  ///
  /// In en, this message translates to:
  /// **'Your usual resting heart rate is {value} BPM.'**
  String assistantUsualHr(String value);

  /// No description provided for @assistantNearbyPresent.
  ///
  /// In en, this message translates to:
  /// **'Nearby PRANA users can receive or forward emergency information on this device.'**
  String get assistantNearbyPresent;

  /// No description provided for @assistantStatusHeading.
  ///
  /// In en, this message translates to:
  /// **'Your current health'**
  String get assistantStatusHeading;

  /// No description provided for @assistantStatusNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get assistantStatusNormal;

  /// No description provided for @assistantStatusElevated.
  ///
  /// In en, this message translates to:
  /// **'Elevated'**
  String get assistantStatusElevated;

  /// No description provided for @assistantStatusEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get assistantStatusEmergency;

  /// No description provided for @assistantSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get assistantSend;

  /// No description provided for @askPranaAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ask PRANA Assistant'**
  String get askPranaAssistant;

  /// No description provided for @healthNav.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthNav;

  /// No description provided for @assistantNav.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistantNav;

  /// No description provided for @moreNav.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreNav;

  /// No description provided for @openHealth.
  ///
  /// In en, this message translates to:
  /// **'Open Health'**
  String get openHealth;

  /// No description provided for @continueDemonstration.
  ///
  /// In en, this message translates to:
  /// **'Continue demonstration'**
  String get continueDemonstration;

  /// No description provided for @compassNorth.
  ///
  /// In en, this message translates to:
  /// **'north'**
  String get compassNorth;

  /// No description provided for @compassNorthEast.
  ///
  /// In en, this message translates to:
  /// **'northeast'**
  String get compassNorthEast;

  /// No description provided for @compassEast.
  ///
  /// In en, this message translates to:
  /// **'east'**
  String get compassEast;

  /// No description provided for @compassSouthEast.
  ///
  /// In en, this message translates to:
  /// **'southeast'**
  String get compassSouthEast;

  /// No description provided for @compassSouth.
  ///
  /// In en, this message translates to:
  /// **'south'**
  String get compassSouth;

  /// No description provided for @compassSouthWest.
  ///
  /// In en, this message translates to:
  /// **'southwest'**
  String get compassSouthWest;

  /// No description provided for @compassWest.
  ///
  /// In en, this message translates to:
  /// **'west'**
  String get compassWest;

  /// No description provided for @compassNorthWest.
  ///
  /// In en, this message translates to:
  /// **'northwest'**
  String get compassNorthWest;

  /// No description provided for @assistantDemonstrationNote.
  ///
  /// In en, this message translates to:
  /// **'These readings are demonstration data.'**
  String get assistantDemonstrationNote;

  /// No description provided for @assistantQuestionWhyStatus.
  ///
  /// In en, this message translates to:
  /// **'Why did my status change?'**
  String get assistantQuestionWhyStatus;

  /// No description provided for @assistantQuestionWhatChanged.
  ///
  /// In en, this message translates to:
  /// **'What changed from my usual readings?'**
  String get assistantQuestionWhatChanged;

  /// No description provided for @assistantQuestionAmIOkay.
  ///
  /// In en, this message translates to:
  /// **'Am I okay?'**
  String get assistantQuestionAmIOkay;

  /// No description provided for @assistantQuestionWhatShouldIDo.
  ///
  /// In en, this message translates to:
  /// **'What should I do?'**
  String get assistantQuestionWhatShouldIDo;

  /// No description provided for @assistantQuestionWhereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where should I go?'**
  String get assistantQuestionWhereToGo;

  /// No description provided for @assistantQuestionWhatIfHelp.
  ///
  /// In en, this message translates to:
  /// **'What if I need help?'**
  String get assistantQuestionWhatIfHelp;

  /// No description provided for @assistantQuestionEmergency.
  ///
  /// In en, this message translates to:
  /// **'What should I do in this emergency?'**
  String get assistantQuestionEmergency;

  /// No description provided for @assistantQuestionWhyAlerted.
  ///
  /// In en, this message translates to:
  /// **'Why was I alerted?'**
  String get assistantQuestionWhyAlerted;

  /// No description provided for @assistantHeadlineHealth.
  ///
  /// In en, this message translates to:
  /// **'Your current health'**
  String get assistantHeadlineHealth;

  /// No description provided for @assistantHeadlineEmergency.
  ///
  /// In en, this message translates to:
  /// **'Current emergency'**
  String get assistantHeadlineEmergency;

  /// No description provided for @assistantHeadlineFall.
  ///
  /// In en, this message translates to:
  /// **'Possible fall check'**
  String get assistantHeadlineFall;

  /// No description provided for @assistantHrHigherUsual.
  ///
  /// In en, this message translates to:
  /// **'Your recent heart rate is higher than your usual resting pattern.'**
  String get assistantHrHigherUsual;

  /// No description provided for @assistantHrSimilarUsual.
  ///
  /// In en, this message translates to:
  /// **'Your recent heart rate is close to your usual resting pattern.'**
  String get assistantHrSimilarUsual;

  /// No description provided for @assistantHrLowerUsual.
  ///
  /// In en, this message translates to:
  /// **'Your recent heart rate is lower than your usual resting pattern.'**
  String get assistantHrLowerUsual;

  /// No description provided for @assistantSpo2LowerUsual.
  ///
  /// In en, this message translates to:
  /// **'Your recent blood oxygen is lower than your usual pattern.'**
  String get assistantSpo2LowerUsual;

  /// No description provided for @assistantSpo2SimilarUsual.
  ///
  /// In en, this message translates to:
  /// **'Your recent blood oxygen is close to your usual pattern.'**
  String get assistantSpo2SimilarUsual;

  /// No description provided for @assistantReadingsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Current readings are unavailable.'**
  String get assistantReadingsUnavailable;

  /// No description provided for @assistantBaselineNotReady.
  ///
  /// In en, this message translates to:
  /// **'A personal baseline is not ready yet.'**
  String get assistantBaselineNotReady;

  /// No description provided for @assistantLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Safer-location guidance is unavailable.'**
  String get assistantLocationUnavailable;

  /// No description provided for @assistantNoDisaster.
  ///
  /// In en, this message translates to:
  /// **'No disaster warning is active on this device.'**
  String get assistantNoDisaster;

  /// No description provided for @assistantSituationLine.
  ///
  /// In en, this message translates to:
  /// **'Current situation: {phase}.'**
  String assistantSituationLine(String phase);

  /// No description provided for @assistantDisasterLine.
  ///
  /// In en, this message translates to:
  /// **'Active warning: {disaster}.'**
  String assistantDisasterLine(String disaster);

  /// No description provided for @assistantAssistanceLimited.
  ///
  /// In en, this message translates to:
  /// **'Assistance stays on this device while connectivity is limited.'**
  String get assistantAssistanceLimited;

  /// No description provided for @assistantAssistanceOnline.
  ///
  /// In en, this message translates to:
  /// **'Emergency information can be forwarded when a path is available.'**
  String get assistantAssistanceOnline;

  /// No description provided for @assistantPacketPresent.
  ///
  /// In en, this message translates to:
  /// **'An emergency event is recorded on this device.'**
  String get assistantPacketPresent;

  /// No description provided for @assistantPacketAbsent.
  ///
  /// In en, this message translates to:
  /// **'No emergency assistance request is recorded yet.'**
  String get assistantPacketAbsent;

  /// No description provided for @assistantConfirmSafe.
  ///
  /// In en, this message translates to:
  /// **'Please confirm whether you are safe.'**
  String get assistantConfirmSafe;

  /// No description provided for @assistantContextElevated.
  ///
  /// In en, this message translates to:
  /// **'The current assessment context is elevated load.'**
  String get assistantContextElevated;

  /// No description provided for @assistantContextExertion.
  ///
  /// In en, this message translates to:
  /// **'The current assessment context is exertion.'**
  String get assistantContextExertion;

  /// No description provided for @assistantContextRest.
  ///
  /// In en, this message translates to:
  /// **'The current assessment context is rest.'**
  String get assistantContextRest;

  /// No description provided for @assistantNotADiagnosis.
  ///
  /// In en, this message translates to:
  /// **'This is a risk assessment, not a medical diagnosis.'**
  String get assistantNotADiagnosis;

  /// No description provided for @assistantHelpPath.
  ///
  /// In en, this message translates to:
  /// **'If you need help, use I need help to record an emergency event on this device.'**
  String get assistantHelpPath;

  /// No description provided for @assistantGoToPlace.
  ///
  /// In en, this message translates to:
  /// **'Recommended safer place: {place}.'**
  String assistantGoToPlace(String place);

  /// No description provided for @assistantTechnicalTitle.
  ///
  /// In en, this message translates to:
  /// **'On-device assistant'**
  String get assistantTechnicalTitle;

  /// No description provided for @assistantTechnicalBody.
  ///
  /// In en, this message translates to:
  /// **'Uses session state, disaster guidance, and location guidance on this device. Does not call a cloud language model.'**
  String get assistantTechnicalBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
