// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'PRANA';

  @override
  String get home => 'होम';

  @override
  String get demo => 'आगे बढ़ें';

  @override
  String get rescue => 'राहत';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get loading => 'PRANA लोड हो रहा है';

  @override
  String get errorContinue => 'वर्तमान सत्र इस उपकरण पर जारी रह सकता है।';

  @override
  String get invalidTransition =>
      'यह क्रिया वर्तमान स्थिति में उपलब्ध नहीं है।';

  @override
  String get phaseNormal => 'सामान्य';

  @override
  String get phaseDisasterAlert => 'आपदा चेतावनी';

  @override
  String get phaseDisasterActive => 'सक्रिय आपदा';

  @override
  String get phaseSurvival => 'उत्तरजीविता';

  @override
  String get phaseEmergencyEvent => 'आपातकालीन घटना';

  @override
  String get phaseResolved => 'समाधान हो गया';

  @override
  String get healthStatus => 'स्वास्थ्य स्थिति';

  @override
  String get personalBaseline => 'व्यक्तिगत आधार रेखा';

  @override
  String get currentReadings => 'वर्तमान रीडिंग';

  @override
  String get recommendations => 'सुझाव';

  @override
  String get heartRate => 'हृदय गति';

  @override
  String get spo2 => 'स्पो२';

  @override
  String get temperature => 'तापमान';

  @override
  String get activity => 'गतिविधि';

  @override
  String get riskLevel => 'जोखिम स्तर';

  @override
  String get riskLow => 'कम';

  @override
  String get riskModerate => 'मध्यम';

  @override
  String get riskHigh => 'उच्च';

  @override
  String get riskCritical => 'गंभीर';

  @override
  String get baselineNotReady =>
      'अभी स्वास्थ्य इतिहास उपलब्ध नहीं है। अपनी व्यक्तिगत आधार रेखा बनाने के लिए PRANA का उपयोग जारी रखें।';

  @override
  String get baselineReady =>
      'आपकी हाल की विश्राम रीडिंग से व्यक्तिगत आधार रेखा तैयार है।';

  @override
  String get bpmUnit => 'बीपीएम';

  @override
  String get percentUnit => '%';

  @override
  String get celsiusUnit => 'से.';

  @override
  String get unavailable => 'उपलब्ध नहीं';

  @override
  String get internetUnavailable => 'इंटरनेट उपलब्ध नहीं है';

  @override
  String get localMonitoringActive => 'स्थानीय निगरानी सक्रिय है';

  @override
  String get emergencyStoredLocally =>
      'आपातकालीन घटना इस उपकरण पर सहेजी गई है।';

  @override
  String get emergencyQueued => 'आपातकालीन घटना कतार में है।';

  @override
  String get emergencyTransmitting => 'आपातकालीन घटना भेजी जा रही है।';

  @override
  String get emergencyTransmitted => 'आपातकालीन घटना प्रेषित की गई।';

  @override
  String get deliveryConfirmed => 'डिलीवरी की पुष्टि हो गई।';

  @override
  String get emergencyFailed =>
      'आपातकालीन प्रेषण असफल रहा। घटना स्थानीय रूप से संग्रहीत है।';

  @override
  String get connectivity => 'कनेक्टिविटी';

  @override
  String get battery => 'बैटरी';

  @override
  String get location => 'स्थान';

  @override
  String get locationUnavailable => 'स्थान उपलब्ध नहीं है।';

  @override
  String get lastKnownLocation => 'अंतिम ज्ञात स्थान';

  @override
  String get fallStatus => 'गिरने की स्थिति';

  @override
  String get fallStatusNone => 'गिरने की घटना नहीं मिली';

  @override
  String get possibleFallDetected => 'संभावित गिरने की घटना का पता चला।';

  @override
  String get awaitingFallConfirmation =>
      'संभावित गिरने की घटना का पता चला। कृपया पुष्टि करें कि आप सुरक्षित हैं।';

  @override
  String get criticalEvent => 'गंभीर घटना';

  @override
  String get iAmOk => 'मैं सुरक्षित हूँ';

  @override
  String get connectivityOnline => 'कनेक्टेड';

  @override
  String get connectivityOffline => 'ऑफलाइन';

  @override
  String get connectivityLimited => 'सीमित कनेक्टिविटी';

  @override
  String get connectivityUnknown => 'अज्ञात';

  @override
  String get flood => 'बाढ़';

  @override
  String get officialWarning => 'आधिकारिक चेतावनी';

  @override
  String get immediateAction => 'तत्काल कार्रवाई';

  @override
  String get floodAction => 'उपयुक्त सुरक्षित स्थान की ओर बढ़ें।';

  @override
  String get floodAvoidWater => 'बहते पानी से दूर रहें।';

  @override
  String get floodAvoidElectrical =>
      'बाढ़ग्रस्त विद्युत क्षेत्रों से दूर रहें।';

  @override
  String get floodFollowGuidance =>
      'उपलब्ध होने पर ज्ञात निकासी निर्देशों का पालन करें।';

  @override
  String get floodDoNotAssumeAltitude =>
      'केवल ऊँचाई को सुरक्षा का प्रमाण न मानें।';

  @override
  String get floodAvoidBridges =>
      'क्षतिग्रस्त पुलों और बाढ़ग्रस्त सड़कों से बचें।';

  @override
  String get floodConserveBattery => 'बैटरी बचाकर रखें।';

  @override
  String get floodKeepCommunication => 'आपातकालीन संचार उपलब्ध रखें।';

  @override
  String get floodSeverity => 'गंभीरता';

  @override
  String get floodSeverityHigh => 'उच्च';

  @override
  String get floodWarningIssued => 'आधिकारिक बाढ़ चेतावनी';

  @override
  String get connectivityRestored => 'कनेक्टिविटी बहाल हुई';

  @override
  String get timeSinceLastCommunication => 'अंतिम संचार के बाद का समय';

  @override
  String get lastCommunicationUnknown => 'अंतिम संचार समय उपलब्ध नहीं है।';

  @override
  String get baselineConfidence => 'आधार रेखा इतिहास';

  @override
  String get sensorAvailability => 'सेंसर उपलब्धता';

  @override
  String get demoResetFull => 'डेमो को सामान्य मोड पर रीसेट करें';

  @override
  String get demoSequenceTitle => 'एसआईएच बाढ़ प्रदर्शन';

  @override
  String get demoStageComplete => 'पूर्ण';

  @override
  String get demoStageCurrent => 'वर्तमान चरण';

  @override
  String get demoStage1Title => 'चरण 1. सामान्य मोड';

  @override
  String get demoStage2Title => 'चरण 2. आधिकारिक बाढ़ चेतावनी';

  @override
  String get demoStage3Title => 'चरण 3. सक्रिय आपदा';

  @override
  String get demoStage4Title => 'चरण 4. कनेक्टिविटी विफलता';

  @override
  String get demoStage5Title => 'चरण 5. उत्तरजीविता मोड';

  @override
  String get demoStage6Title => 'चरण 6. गिरना और स्थिति परिवर्तन';

  @override
  String get demoStage7Title => 'चरण 7. आपातकालीन पैकेट';

  @override
  String get demoStage8Title => 'चरण 8. कनेक्टिविटी बहाल';

  @override
  String get demoStage9Title => 'चरण 9. राहत डैशबोर्ड';

  @override
  String get demoStage1Body =>
      'चिह्नित सामान्य रीडिंग चलाएँ। PRANA वास्तविक अनुमान पाइपलाइन से व्यक्तिगत आधार रेखा सीखता है।';

  @override
  String get demoStage2Body =>
      'आधिकारिक बाढ़ चेतावनी दर्ज करें। PRANA सामान्य से आपदा चेतावनी पर जाता है।';

  @override
  String get demoStage3Body =>
      'आपदा की पुष्टि करें। स्थानीय सूची से संरचित बाढ़ मार्गदर्शन दिखता है।';

  @override
  String get demoStage4Body =>
      'इंटरनेट और बैकएंड कनेक्टिविटी का नुकसान सिम्युलेट करें। निगरानी और मार्गदर्शन इसी उपकरण पर रहते हैं।';

  @override
  String get demoStage5Body =>
      'उपयोगकर्ता फँस गया है। उत्तरजीविता मोड बिना क्लाउड यात्रा के स्थानीय निगरानी जारी रखता है।';

  @override
  String get demoStage6Body =>
      'स्थिति परिवर्तन और गिरने के सेंसर क्रम चलाएँ। गिरने की पहचान में अभी भी तीव्र परिवर्तन, प्रभाव, दिशा, निष्क्रियता और पुष्टि आवश्यक है।';

  @override
  String get demoStage7Body =>
      'अनुप्रयोग पाइपलाइन से आपातकालीन रिकॉर्ड बनाएँ। यह स्थानीय रूप से संग्रहीत होता है और अभी वितरित नहीं माना जाता।';

  @override
  String get demoStage8Body =>
      'सिम्युलेटेड कनेक्टिविटी बहाल करें। संचार पुष्टि के बाद ही पैकेट आगे बढ़ता है।';

  @override
  String get demoStage9Body =>
      'उसी संग्रहीत पैकेट का राहत दृश्य खोलें। यह अलग से बनाया गया नकली ऑब्जेक्ट नहीं है।';

  @override
  String get demoNextStage => 'आगे बढ़ें';

  @override
  String get demoPreviousStage => 'पिछला चरण';

  @override
  String get demoAutoPlay => 'शेष चरण चलाएँ';

  @override
  String get demoStopAutoPlay => 'रोकें';

  @override
  String demoStageProgress(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get simulatedConnectivity =>
      'यहाँ दिखाई गई कनेक्टिविटी प्रोटोटाइप के लिए सिम्युलेटेड है।';

  @override
  String get recentHealthEvents => 'हाल की स्वास्थ्य घटनाएँ';

  @override
  String get noRecentHealthEvents =>
      'इस सत्र में अभी कोई स्वास्थ्य घटना दर्ज नहीं हुई है।';

  @override
  String get aboutAarogya => 'PRANA के बारे में';

  @override
  String get appVersionLabel => 'संस्करण';

  @override
  String get appVersionValue => '0.1.0';

  @override
  String get presentationTarget =>
      'एसआईएच प्रस्तुति लक्ष्य यह ब्राउज़र डेमो है। दीर्घकालिक उत्पाद मोबाइल साथी ही रहेगा।';

  @override
  String get medicalDisclaimerShort =>
      'PRANA एक जोखिम पहचान और आपातकालीन सहायता प्रणाली है। यह चिकित्सकीय निदान प्रणाली नहीं है।';

  @override
  String get packetStoredLocally => 'स्थानीय रूप से संग्रहीत';

  @override
  String get packetPendingDelivery => 'प्रेषण लंबित';

  @override
  String get packetDelivered => 'वितरित';

  @override
  String get openRescueDashboard => 'राहत डैशबोर्ड खोलें';

  @override
  String get rescueEmptyHint =>
      'अभी कोई आपातकालीन पैकेट संग्रहीत नहीं है। प्रदर्शन से वास्तविक पाइपलाइन के माध्यम से एक पैकेट बनाएँ।';

  @override
  String get demoSessionState => 'वर्तमान सत्र';

  @override
  String get webPresentationHint =>
      'प्रत्येक चरण वास्तविक PRANA पाइपलाइन में डेटा या आधिकारिक घटना भेजता है।';

  @override
  String get simulationData => 'प्रदर्शन डेटा';

  @override
  String get simulationNotice =>
      'ये रीडिंग प्रदर्शन डेटा के रूप में चिह्नित हैं और नैदानिक प्रमाण नहीं हैं।';

  @override
  String get demoTitle => 'प्रदर्शन नियंत्रण';

  @override
  String get demoReplayNormal => 'सामान्य आधार रेखा डेटासेट चलाएँ';

  @override
  String get demoFloodWarning => 'आधिकारिक बाढ़ चेतावनी दर्ज करें';

  @override
  String get demoConfirmDisaster => 'सक्रिय आपदा की पुष्टि करें';

  @override
  String get demoReplayFlood => 'बाढ़ परिश्रम डेटासेट चलाएँ';

  @override
  String get demoGoOffline => 'कनेक्टिविटी ऑफलाइन करें';

  @override
  String get demoEnterSurvival => 'उत्तरजीविता मोड में जाएँ';

  @override
  String get demoReplayDeterioration => 'शारीरिक स्थिति परिवर्तन चलाएँ';

  @override
  String get demoReplayFall => 'गिरने का क्रम चलाएँ';

  @override
  String get demoRestoreConnectivity => 'कनेक्टिविटी बहाल करें';

  @override
  String get demoEscalateFall => 'अपुष्ट गिरने की घटना को आगे बढ़ाएँ';

  @override
  String get demoResolve => 'आपातकाल का समाधान करें';

  @override
  String get demoReset => 'सामान्य स्थिति पर लौटें';

  @override
  String get rescueDashboard => 'आपातकालीन प्रतिक्रिया';

  @override
  String get noEmergencyPackets =>
      'कोई आपातकालीन पैकेट संग्रहीत या प्राप्त नहीं हुआ है।';

  @override
  String get packetState => 'पैकेट स्थिति';

  @override
  String get eventType => 'घटना प्रकार';

  @override
  String get eventId => 'घटना पहचान';

  @override
  String get eventTimestamp => 'समय';

  @override
  String get communicationStatus => 'संचार स्थिति';

  @override
  String get deviceId => 'उपकरण';

  @override
  String get whatHappened => 'क्या हुआ';

  @override
  String get howSerious => 'कितना गंभीर';

  @override
  String get whatToDo => 'आपको क्या करना चाहिए';

  @override
  String get movementNone => 'कोई नहीं';

  @override
  String get movementLow => 'कम';

  @override
  String get movementNormal => 'सामान्य';

  @override
  String get movementHigh => 'अधिक';

  @override
  String get movementIrregular => 'अनियमित';

  @override
  String get reasonHrAboveBaseline =>
      'हृदय गति आपकी सामान्य आधार रेखा से काफी अधिक है।';

  @override
  String get reasonSpo2BelowBaseline =>
      'स्पो२ आपकी हाल की आधार रेखा से घट गई है।';

  @override
  String get reasonProlongedActivity =>
      'लंबे समय तक शारीरिक गतिविधि का पता चला।';

  @override
  String get reasonHighHrLowMovement =>
      'गतिविधि कम होने पर भी हृदय गति बढ़ी हुई है।';

  @override
  String get reasonEnvironmentalStress =>
      'आपदा की स्थिति वर्तमान रीडिंग का महत्व बढ़ाती है।';

  @override
  String get reasonLimitedSensors =>
      'कुछ सेंसर उपलब्ध नहीं हैं। जोखिम शेष संकेतों पर आधारित है।';

  @override
  String get reasonInsufficientHistory =>
      'जोखिम का आकलन करने के लिए पर्याप्त व्यक्तिगत इतिहास नहीं है।';

  @override
  String get reasonPossibleFall => 'संभावित गिरने के क्रम का पता चला।';

  @override
  String get reasonModelExertion =>
      'हृदय गति में परिवर्तन को शारीरिक गतिविधि के साथ समझा जा रहा है।';

  @override
  String get reasonModelElevatedLoad =>
      'आपकी रीडिंग आपकी सामान्य विश्राम स्थिति से भिन्न हैं।';

  @override
  String get readingsDifferFromBaseline =>
      'आपकी वर्तमान रीडिंग आपकी सामान्य आधार रेखा से काफी भिन्न हैं।';

  @override
  String get elevatedHealthRisk => 'बढ़ा हुआ स्वास्थ्य जोखिम पाया गया।';

  @override
  String get emergencyEventRecorded => 'आपातकालीन घटना दर्ज की गई।';

  @override
  String get engineVersion => 'इंजन संस्करण';

  @override
  String get homeGuidanceNormal =>
      'नियमित निगरानी जारी रखें। PRANA इसी उपकरण पर रहता है।';

  @override
  String get continueUsing => 'PRANA का उपयोग जारी रखें।';

  @override
  String get disasterType => 'आपदा प्रकार';

  @override
  String get activationSource => 'सक्रियण स्रोत';

  @override
  String get userActivation => 'उपयोगकर्ता सक्रियण';

  @override
  String get localDetection => 'समर्थित स्थानीय पहचान';

  @override
  String get productTagline => 'व्यक्तिगत स्वास्थ्य और आपातकालीन सहायता';

  @override
  String get startDisasterDemo => 'आपदा प्रदर्शन शुरू करें';

  @override
  String get simulationBadge => 'प्रदर्शन डेटा';

  @override
  String stageHeroLabel(String number) {
    return 'चरण $number';
  }

  @override
  String get stageShort1 => 'आपकी सेहत';

  @override
  String get stageShort2 => 'आपात';

  @override
  String get stageShort3 => 'सुरक्षित स्थान';

  @override
  String get stageShort4 => 'मदद?';

  @override
  String get stageShort5 => 'आस-पास';

  @override
  String get stageShort6 => 'प्रतिक्रिया';

  @override
  String get stageShort7 => 'आपातकालीन पैकेट';

  @override
  String get stageShort8 => 'संचार बहाल';

  @override
  String get stageShort9 => 'राहत';

  @override
  String get demoStage1Hero => 'आपकी सेहत';

  @override
  String get demoStage1HeroBody =>
      'अपनी सामान्य रीडिंग और वर्तमान स्वास्थ्य आकलन देखें।';

  @override
  String get demoStage2Hero => 'आपात स्थिति';

  @override
  String get demoStage2HeroBody =>
      'आधिकारिक बाढ़ चेतावनी अब सक्रिय है। इस स्क्रीन पर दिए मार्गदर्शन का पालन करें।';

  @override
  String get demoStage3Hero => 'सुरक्षित स्थान';

  @override
  String get demoStage3HeroBody =>
      'एक अनुशंसित सुरक्षित स्थान और उसे चुनने का कारण दिखाया गया है।';

  @override
  String get demoStage4Hero => 'मदद चाहिए?';

  @override
  String get demoStage4HeroBody =>
      'संभावित गिरना पाया गया। पुष्टि करें कि क्या आपको सहायता चाहिए।';

  @override
  String get demoStage5Hero => 'आस-पास के PRANA उपयोगकर्ता';

  @override
  String get demoStage5HeroBody =>
      'आस-पास के PRANA उपयोगकर्ताओं के साथ आपातकालीन जानकारी प्राप्त करें या आगे भेजें।';

  @override
  String get demoStage6Hero => 'आपातकालीन प्रतिक्रिया';

  @override
  String get demoStage6HeroBody =>
      'उसी आपातकालीन रिकॉर्ड का प्रतिक्रिया दृश्य खोलें।';

  @override
  String get demoStage7Hero => 'आपातकालीन पैकेट';

  @override
  String get demoStage7HeroBody =>
      'आपातकालीन रिकॉर्ड संचार उपलब्ध होने तक इसी उपकरण पर संग्रहीत रहता है।';

  @override
  String get demoStage8Hero => 'संचार बहाल';

  @override
  String get demoStage8HeroBody =>
      'सिम्युलेटेड कनेक्टिविटी लौट आई है। संचार पुष्टि के बाद ही पैकेट आगे बढ़ता है।';

  @override
  String get demoStage9Hero => 'राहत डैशबोर्ड';

  @override
  String get demoStage9HeroBody =>
      'राहत दृश्य उसी संग्रहीत आपातकालीन पैकेट को दिखाता है जो प्रदर्शन से बना है।';

  @override
  String get modeChipNormal => 'सामान्य';

  @override
  String get modeChipDisasterAlert => 'आपदा चेतावनी';

  @override
  String get modeChipDisasterActive => 'सक्रिय आपदा';

  @override
  String get modeChipSurvival => 'उत्तरजीविता';

  @override
  String get modeChipEmergency => 'आपात';

  @override
  String get modeChipResolved => 'समाधान';

  @override
  String get capabilityLocalMonitoring => 'स्थानीय निगरानी';

  @override
  String get capabilityLocalInference => 'स्थानीय आकलन';

  @override
  String get capabilityLocalStorage => 'स्थानीय संग्रह';

  @override
  String get capabilityDisasterGuidance => 'आपदा मार्गदर्शन';

  @override
  String get capabilityEmergencyProcessing => 'आपातकालीन प्रसंस्करण';

  @override
  String get capabilityActive => 'सक्रिय';

  @override
  String get capabilityAvailable => 'उपलब्ध';

  @override
  String get networkLabel => 'नेटवर्क';

  @override
  String get fallStepSpike => 'गति में तीव्र परिवर्तन';

  @override
  String get fallStepImpact => 'प्रभाव का पता चला';

  @override
  String get fallStepOrientation => 'दिशा परिवर्तन';

  @override
  String get fallStepInactivity => 'निष्क्रियता का पता चला';

  @override
  String get fallStepConfirmation => 'पुष्टि अवधि';

  @override
  String get fallStepEmergency => 'आपातकालीन घटना की पुष्टि';

  @override
  String get packetLocalOnly => 'केवल स्थानीय';

  @override
  String get packetPending => 'लंबित';

  @override
  String get packetSentDelivered => 'भेजा / वितरित';

  @override
  String get affectedArea => 'प्रभावित क्षेत्र';

  @override
  String get demoLocationKathmandu => 'काठमांडू घाटी प्रदर्शन क्षेत्र';

  @override
  String get confidenceLabel => 'विश्वास';

  @override
  String get inferenceSource => 'अनुमान स्रोत';

  @override
  String get inferenceTrainedModel => 'डिवाइस पर प्रशिक्षित मॉडल';

  @override
  String get inferenceRulesOnly => 'केवल आधार-रेखा नियम';

  @override
  String get physioContext => 'शारीरिक संदर्भ';

  @override
  String get physioContextRest => 'विश्राम';

  @override
  String get physioContextExertion => 'श्रम';

  @override
  String get physioContextElevatedLoad => 'उच्च शारीरिक भार';

  @override
  String get modelConfidence => 'मॉडल विश्वास';

  @override
  String get researchRecording => 'शोध रिकॉर्डिंग';

  @override
  String get riskScoreLabel => 'जोखिम अंक';

  @override
  String get sensorSourceLabel => 'सेंसर स्रोत';

  @override
  String get sensorSourceSimulation => 'प्रदर्शन डेटा';

  @override
  String get sensorSourceDataset => 'शोध रिकॉर्डिंग';

  @override
  String get sensorSourceWearable => 'पहनने योग्य उपकरण';

  @override
  String get recentHeartRate => 'हाल की हृदय गति';

  @override
  String get heartRateNowUsual => 'हृदय गति अब / सामान्य';

  @override
  String get spo2NowUsual => 'स्पो२ अब / सामान्य';

  @override
  String get windowHeartRate => 'हाल की अवधि की हृदय गति';

  @override
  String get riskInputs => 'जोखिम इनपुट';

  @override
  String riskInputsValue(String rules, String model) {
    return 'नियम $rules · प्रशिक्षित संदर्भ $model';
  }

  @override
  String get fallCheck => 'गिरने की जाँच';

  @override
  String get fallCheckSimulated => 'गिरने की पहचान: प्रदर्शन मोड';

  @override
  String get assessmentWhyHeading => 'यह आकलन क्यों';

  @override
  String alertHrVsBaseline(String current, String usual) {
    return 'हृदय गति $current बीपीएम है, सामान्य विश्राम $usual बीपीएम की तुलना में।';
  }

  @override
  String alertSpo2VsBaseline(String current, String usual) {
    return 'स्पो२ $current% है, सामान्य $usual% की तुलना में।';
  }

  @override
  String alertModelDetected(String context, String confidence) {
    return 'स्वास्थ्य आकलन: $context ($confidence% विश्वास)।';
  }

  @override
  String get alertRiskCombined =>
      'वर्तमान रीडिंग और आपकी व्यक्तिगत आधार रेखा से जोखिम बढ़ा।';

  @override
  String get modelPipelineNote =>
      'आकलन आपकी हाल की रीडिंग और व्यक्तिगत आधार रेखा पर आधारित है।';

  @override
  String get usualRestHeartRate => 'सामान्य विश्राम हृदय गति';

  @override
  String get usualRestSpo2 => 'सामान्य विश्राम स्पो२';

  @override
  String get fallDetectionMode => 'गिरने की पहचान';

  @override
  String get fallDetectionSimulated => 'प्रदर्शन मोड';

  @override
  String get yourHealth => 'आपका स्वास्थ्य';

  @override
  String get emergencyInformation => 'आपातकालीन जानकारी';

  @override
  String get emergencyAssistance => 'आपातकालीन सहायता';

  @override
  String get emergencyResponse => 'आपातकालीन प्रतिक्रिया';

  @override
  String get healthAssessment => 'स्वास्थ्य आकलन';

  @override
  String get assessmentConfidence => 'आकलन विश्वास';

  @override
  String get assessmentFromReadings =>
      'आकलन आपकी हाल की रीडिंग और व्यक्तिगत आधार रेखा पर आधारित है।';

  @override
  String get demonstrationData => 'प्रदर्शन डेटा';

  @override
  String get technicalInformation => 'तकनीकी जानकारी';

  @override
  String get technicalInformationHint =>
      'केवल मूल्यांकन के लिए। ये विवरण सार्वजनिक स्वास्थ्य स्क्रीन पर नहीं दिखते।';

  @override
  String get accountSection => 'खाता';

  @override
  String get signIn => 'साइन इन';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get register => 'पंजीकरण';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? साइन इन करें';

  @override
  String get needAccount => 'खाता चाहिए? पंजीकरण करें';

  @override
  String get signedInAs => 'साइन इन';

  @override
  String get sessionPersistsHint =>
      'साइन आउट करने तक आपका खाता इसी उपकरण पर साइन इन रहता है।';

  @override
  String get dataStaysOnDevice =>
      'स्वास्थ्य आकलन इसी उपकरण पर रहता है। साइन-इन सिंक केवल आपके खाते के आवश्यक रिकॉर्ड संग्रहीत करता है।';

  @override
  String get authRequiredHint =>
      'इस उपकरण पर PRANA का उपयोग करने के लिए साइन इन करें।';

  @override
  String get passwordTooShort => 'कम से कम 8 अक्षरों का पासवर्ड उपयोग करें।';

  @override
  String get invalidCredentials => 'ईमेल या पासवर्ड सत्यापित नहीं हो सका।';

  @override
  String get registrationFailed => 'खाता नहीं बन सका। कोई अन्य ईमेल आज़माएँ।';

  @override
  String get nameRequired => 'अपना नाम लिखें।';

  @override
  String get emailRequired => 'मान्य ईमेल पता लिखें।';

  @override
  String get deviceIdentifier => 'उपकरण पहचान';

  @override
  String get userIdentifier => 'उपयोगकर्ता पहचान';

  @override
  String get peerNetworkNotActive =>
      'निकटवर्ती साझाकरण इसी ब्राउज़र प्रदर्शन रिले का उपयोग करता है। यह ब्लूटूथ या मेश रेडियो नहीं है।';

  @override
  String get publicLandingBody =>
      'साइन इन करें ताकि आपकी आधार रेखा और आपातकालीन जानकारी इसी खाते में रहे।';

  @override
  String get syncWhenConnected =>
      'आपातकालीन जानकारी पहले इसी उपकरण पर संग्रहीत होती है, फिर कनेक्टिविटी उपलब्ध होने पर समन्वयित होती है।';

  @override
  String get emailOrMobile => 'ईमेल / मोबाइल';

  @override
  String get identifierRequired => 'मान्य ईमेल पता या मोबाइल नंबर लिखें।';

  @override
  String get dontHaveAccount => 'खाता नहीं है?';

  @override
  String get continueAsDemoUser => 'प्रदर्शन उपयोगकर्ता के रूप में जारी रखें';

  @override
  String get demoAccountHint =>
      'यह एक प्रदर्शन खाता खोलता है। यह वही स्वास्थ्य और आपातकालीन पाइपलाइन उपयोग करता है, और व्यक्तिगत खातों से अलग रहता है।';

  @override
  String get myAccount => 'मेरा खाता';

  @override
  String get accountNav => 'खाता';

  @override
  String get accountIdentifier => 'खाता';

  @override
  String get healthDataStatus => 'स्वास्थ्य डेटा';

  @override
  String get emergencyRecords => 'आपातकालीन रिकॉर्ड';

  @override
  String get demonstrationAccount => 'प्रदर्शन खाता';

  @override
  String get baselineReadyShort => 'व्यक्तिगत आधार रेखा तैयार है';

  @override
  String get baselineNotReadyShort => 'व्यक्तिगत आधार रेखा अभी तैयार नहीं है';

  @override
  String readingCount(int count) {
    return '$count संग्रहीत रीडिंग';
  }

  @override
  String packetCount(int count) {
    return '$count आपातकालीन रिकॉर्ड';
  }

  @override
  String get duplicateAccount =>
      'इस ईमेल या मोबाइल नंबर से खाता पहले से मौजूद है।';

  @override
  String get sensorSourceDevice => 'कनेक्टेड उपकरण';

  @override
  String get nearbyAarogyaUsers => 'निकटवर्ती PRANA उपयोगकर्ता';

  @override
  String get nearbyRelayHint =>
      'इस उपकरण पर निकटवर्ती साझा करना एक ब्राउज़र प्रदर्शन है। यह ब्लूटूथ या मेश रेडियो नहीं है।';

  @override
  String get noNearbyUsers =>
      'अभी कोई अन्य साइन-इन PRANA सत्र निकटवर्ती साझा नहीं कर रहा है।';

  @override
  String get forwardEmergency => 'आगे भेजें';

  @override
  String get forwardedNearby => 'निकटवर्ती PRANA उपयोगकर्ताओं को भेजा गया';

  @override
  String get connectedDevice => 'कनेक्टेड उपकरण';

  @override
  String get connectHeartRate => 'हृदय गति मॉनिटर जोड़ें';

  @override
  String get heartRateBrowserOnly =>
      'हृदय गति कनेक्शन उन ब्राउज़रों में उपलब्ध है जो ब्लूटूथ सहायक उपकरण समर्थित करते हैं। यह Apple Watch या Fitbit पेयरिंग नहीं है।';

  @override
  String get heartRateUnavailableBrowser =>
      'इस ब्राउज़र में हृदय गति सहायक उपकरण कनेक्शन उपलब्ध नहीं है।';

  @override
  String get currentLocation => 'वर्तमान स्थान';

  @override
  String get demonstrationLocation => 'प्रदर्शन स्थान';

  @override
  String get gpsLocation => 'उपकरण स्थान';

  @override
  String get requestLocation => 'उपकरण स्थान उपयोग करें';

  @override
  String get saferLocation => 'अधिक सुरक्षित स्थान';

  @override
  String get saferLocationRecommended =>
      'उपलब्ध आपातकालीन और भौगोलिक जानकारी के आधार पर सुझाव।';

  @override
  String get notDefinitelySafe =>
      'इसका अर्थ यह नहीं कि स्थान निश्चित रूप से सुरक्षित है।';

  @override
  String get directionAndDistance =>
      'उपलब्ध निर्देशांकों से दिशा और दूरी। यह मोड़-दर-मोड़ सड़क नेविगेशन नहीं है।';

  @override
  String get mapTilesNeedNetwork =>
      'मानचित्र टाइल के लिए नेटवर्क चाहिए। दूरी और दिशा सहेजी गई भौगोलिक जानकारी से काम करती हैं।';

  @override
  String get osmAttribution => 'मानचित्र टाइल © OpenStreetMap योगदानकर्ता';

  @override
  String distanceAndBearing(String distance, String direction) {
    return '$distance मी $direction';
  }

  @override
  String get insideHazardArea => 'आप एक प्रदर्शन जोखिम क्षेत्र में हैं।';

  @override
  String get fallCheckOnDevice => 'गिरने की जाँच: उपकरण पर आकलन';

  @override
  String get receivedNearby => 'निकट से प्राप्त';

  @override
  String get thisAccountEmergency => 'यह खाता';

  @override
  String get eventTypePossibleFall => 'संभावित गिरना';

  @override
  String get eventTypeDeterioration => 'बढ़ा हुआ स्वास्थ्य जोखिम';

  @override
  String fromUser(String name) {
    return '$name से';
  }

  @override
  String get nearbyRelayTechnical =>
      'निकटवर्ती साझाकरण उसी ओरिजिन के ब्राउज़र प्रदर्शन रिले का उपयोग करता है (ब्लूटूथ नहीं)।';

  @override
  String get inMemoryTransportTechnical =>
      'इन-मेमोरी प्रदर्शन ट्रांसपोर्ट (परीक्षण)।';

  @override
  String get accelAvailable => 'गति सेंसर';

  @override
  String get gyroAvailable => 'घूर्णन सेंसर';

  @override
  String get availableShort => 'उपलब्ध';

  @override
  String get sourceLabel => 'स्रोत';

  @override
  String get iNeedHelp => 'मुझे सहायता चाहिए';

  @override
  String get fallCheckCancelled =>
      'गिरने की जाँच रद्द हुई। कोई आपातकालीन पैकेट नहीं बना।';

  @override
  String get receiveEmergency => 'प्राप्त करें';

  @override
  String get emergencyInformationAvailable => 'आपातकालीन जानकारी उपलब्ध है';

  @override
  String get nearbySharingHint =>
      'इस उपकरण पर निकटवर्ती साझा करना एक ब्राउज़र प्रदर्शन है। यह ब्लूटूथ या मेश रेडियो नहीं है।';

  @override
  String get noNearbySaferLocation => 'निकट कोई सुरक्षित स्थान नहीं मिला।';

  @override
  String get recommendedSaferLocation => 'अनुशंसित अधिक सुरक्षित स्थान';

  @override
  String get directionToSaferLocation => 'अधिक सुरक्षित स्थान की दिशा';

  @override
  String get demonstrationAreaKathmandu => 'काठमांडू बाढ़ क्षेत्र';

  @override
  String get demonstrationAreaDelhi => 'दिल्ली क्षेत्र';

  @override
  String get locationOutsideDemonstration =>
      'उपकरण स्थान निर्धारित प्रदर्शन क्षेत्रों के बाहर है। वर्तमान प्रदर्शन क्षेत्र नहीं बदला।';

  @override
  String get replayDemonstrationReadings => 'प्रदर्शन रीडिंग चलाएँ';

  @override
  String get currentSituation => 'वर्तमान स्थिति';

  @override
  String get currentCondition => 'वर्तमान दशा';

  @override
  String get recommendedAction => 'अनुशंसित कार्रवाई';

  @override
  String get assistanceStatus => 'सहायता की स्थिति';

  @override
  String get myEmergencyInformation => 'मेरी आपातकालीन जानकारी';

  @override
  String get selectSaferLocation => 'अधिक सुरक्षित स्थान चुनें';

  @override
  String get bloodOxygen => 'रक्त ऑक्सीजन';

  @override
  String get limitedConnectivity => 'सीमित कनेक्टिविटी';

  @override
  String get situationNormal => 'सामान्य';

  @override
  String get situationEmergency => 'आपातकाल';

  @override
  String get personLabel => 'व्यक्ति';

  @override
  String get statusLabel => 'स्थिति';

  @override
  String get timeLabel => 'समय';

  @override
  String get healthSummary => 'स्वास्थ्य सारांश';

  @override
  String get pranaTaglineFull =>
      'Privacy-preserving Resilience & Adaptive Neural Assistant';

  @override
  String get useDeviceLocation => 'उपकरण स्थान उपयोग करें';

  @override
  String get demonstrationConditions => 'प्रदर्शन स्थितियाँ';

  @override
  String get conditionResting => 'विश्राम';

  @override
  String get conditionPhysicalActivity => 'शारीरिक गतिविधि';

  @override
  String get conditionHighLoad => 'अधिक भार';

  @override
  String get conditionFallImpact => 'गिरना / टकराव';

  @override
  String get whyRecommended => 'यह स्थान क्यों सुझाया गया';

  @override
  String get mapLegendYou => 'आप यहाँ हैं';

  @override
  String get mapLegendAffected => 'प्रभावित क्षेत्र';

  @override
  String get mapLegendSafer => 'अनुशंसित सुरक्षित स्थान';

  @override
  String get reasonOutsideHazard => 'यह स्थान प्रभावित क्षेत्र के बाहर है।';

  @override
  String get reasonOpenSpace => 'यह एक खुला स्थान है।';

  @override
  String get reasonNearestInRegion =>
      'यह इस क्षेत्र में निकटतम उपयुक्त स्थान है।';

  @override
  String get reasonUnderGuidanceLimit =>
      'यह स्थानीय 15 किमी मार्गदर्शन सीमा के अंदर है।';

  @override
  String get howItReachedUs => 'यह जानकारी कैसे पहुँची';

  @override
  String get reachedFromThisAccount => 'इसी खाते पर दर्ज।';

  @override
  String get reachedFromNearbyUser => 'आस-पास के PRANA उपयोगकर्ता से प्राप्त।';

  @override
  String get urgencyLabel => 'तात्कालिकता';

  @override
  String get pranaAssistant => 'PRANA सहायक';

  @override
  String get assistantHowCanIHelp => 'मैं आपकी कैसे सहायता करूँ?';

  @override
  String get assistantAskHint => 'इस सत्र के बारे में पूछें';

  @override
  String get assistantAsk => 'पूछें';

  @override
  String get assistantUnrecognized =>
      'आपके वर्तमान PRANA डेटा से मैं इस प्रश्न का उत्तर नहीं दे सकता।';

  @override
  String get assistantInsufficient =>
      'आपके वर्तमान PRANA डेटा से मैं इस प्रश्न का उत्तर नहीं दे सकता।';

  @override
  String get assistantCanHelpWith =>
      'मैं आपकी वर्तमान रीडिंग, सामान्य पैटर्न, सुरक्षित स्थान और आपातकालीन मार्गदर्शन समझा सकता हूँ।';

  @override
  String get assistantReadingsClose =>
      'आपकी हाल की रीडिंग आपके सामान्य पैटर्न के निकट हैं। वर्तमान आधार रेखा से कोई स्पष्ट अंतर नहीं मिला।';

  @override
  String get assistantRestAndRecheck =>
      'यदि आप हाल में सक्रिय रहे हैं, तो कुछ मिनट विश्राम करें और फिर जाँचें।';

  @override
  String get assistantFallExplain =>
      'PRANA ने ऐसा गतिविधि पैटर्न पाया है जिससे गिरने की संभावना हो सकती है। कृपया पुष्टि करें कि आप सुरक्षित हैं।';

  @override
  String get assistantEmergencyAttention =>
      'आपकी वर्तमान स्थिति पर ध्यान देना आवश्यक है। PRANA के पास आपकी आपातकालीन जानकारी और वर्तमान स्थान उपलब्ध है। अनुशंसित सुरक्षा मार्गदर्शन का पालन करें।';

  @override
  String get assistantOfflineLocal =>
      'स्थानीय निगरानी, स्वास्थ्य आकलन, सहेजा गया मार्गदर्शन और आपातकालीन रिकॉर्ड इसी उपकरण पर चलते रहते हैं। अग्रेषण कनेक्शन उपलब्ध होने तक प्रतीक्षा करता है।';

  @override
  String get assistantNoSaferPlace =>
      'अभी कोई उपयुक्त सुरक्षित स्थान उपलब्ध नहीं है।';

  @override
  String assistantSaferPlaceApprox(
    String place,
    String meters,
    String direction,
  ) {
    return 'अनुशंसित सुरक्षित स्थान $place है, आपकी वर्तमान स्थिति से लगभग $meters मीटर $direction।';
  }

  @override
  String assistantUsualHr(String value) {
    return 'आपकी सामान्य विश्राम हृदय गति $value बीपीएम है।';
  }

  @override
  String get assistantNearbyPresent =>
      'आस-पास के PRANA उपयोगकर्ता इस उपकरण पर आपातकालीन जानकारी प्राप्त या अग्रेषित कर सकते हैं।';

  @override
  String get assistantStatusHeading => 'आपका वर्तमान स्वास्थ्य';

  @override
  String get assistantStatusNormal => 'सामान्य';

  @override
  String get assistantStatusElevated => 'उच्च';

  @override
  String get assistantStatusEmergency => 'आपातकाल';

  @override
  String get assistantSend => 'भेजें';

  @override
  String get askPranaAssistant => 'PRANA सहायक से पूछें';

  @override
  String get healthNav => 'स्वास्थ्य';

  @override
  String get assistantNav => 'PRANA AI';

  @override
  String get moreNav => 'और';

  @override
  String get openHealth => 'स्वास्थ्य खोलें';

  @override
  String get continueDemonstration => 'प्रदर्शन जारी रखें';

  @override
  String get compassNorth => 'उत्तर';

  @override
  String get compassNorthEast => 'उत्तर-पूर्व';

  @override
  String get compassEast => 'पूर्व';

  @override
  String get compassSouthEast => 'दक्षिण-पूर्व';

  @override
  String get compassSouth => 'दक्षिण';

  @override
  String get compassSouthWest => 'दक्षिण-पश्चिम';

  @override
  String get compassWest => 'पश्चिम';

  @override
  String get compassNorthWest => 'उत्तर-पश्चिम';

  @override
  String get assistantDemonstrationNote => 'ये रीडिंग प्रदर्शन डेटा हैं।';

  @override
  String get assistantQuestionWhyStatus => 'मेरी स्थिति क्यों बदली?';

  @override
  String get assistantQuestionWhatChanged =>
      'मेरी सामान्य रीडिंग से क्या बदला?';

  @override
  String get assistantQuestionAmIOkay => 'क्या मैं ठीक हूँ?';

  @override
  String get assistantQuestionWhatShouldIDo => 'मुझे क्या करना चाहिए?';

  @override
  String get assistantQuestionWhereToGo => 'मुझे कहाँ जाना चाहिए?';

  @override
  String get assistantQuestionWhatIfHelp =>
      'यदि मुझे सहायता चाहिए तो क्या करूँ?';

  @override
  String get assistantQuestionEmergency =>
      'इस आपातकाल में मुझे क्या करना चाहिए?';

  @override
  String get assistantQuestionWhyAlerted => 'मुझे चेतावनी क्यों मिली?';

  @override
  String get assistantHeadlineHealth => 'आपका वर्तमान स्वास्थ्य';

  @override
  String get assistantHeadlineEmergency => 'वर्तमान आपातकाल';

  @override
  String get assistantHeadlineFall => 'संभावित गिरने की जाँच';

  @override
  String get assistantHrHigherUsual =>
      'आपकी हाल की हृदय गति आपके सामान्य विश्राम पैटर्न से अधिक है।';

  @override
  String get assistantHrSimilarUsual =>
      'आपकी हाल की हृदय गति आपके सामान्य विश्राम पैटर्न के निकट है।';

  @override
  String get assistantHrLowerUsual =>
      'आपकी हाल की हृदय गति आपके सामान्य विश्राम पैटर्न से कम है।';

  @override
  String get assistantSpo2LowerUsual =>
      'आपकी हाल की रक्त ऑक्सीजन आपके सामान्य पैटर्न से कम है।';

  @override
  String get assistantSpo2SimilarUsual =>
      'आपकी हाल की रक्त ऑक्सीजन आपके सामान्य पैटर्न के निकट है।';

  @override
  String get assistantReadingsUnavailable => 'वर्तमान रीडिंग उपलब्ध नहीं हैं।';

  @override
  String get assistantBaselineNotReady =>
      'व्यक्तिगत आधार रेखा अभी तैयार नहीं है।';

  @override
  String get assistantLocationUnavailable =>
      'अधिक सुरक्षित स्थान का मार्गदर्शन उपलब्ध नहीं है।';

  @override
  String get assistantNoDisaster =>
      'इस उपकरण पर कोई आपदा चेतावनी सक्रिय नहीं है।';

  @override
  String assistantSituationLine(String phase) {
    return 'वर्तमान स्थिति: $phase।';
  }

  @override
  String assistantDisasterLine(String disaster) {
    return 'सक्रिय चेतावनी: $disaster।';
  }

  @override
  String get assistantAssistanceLimited =>
      'कनेक्टिविटी सीमित होने पर सहायता इसी उपकरण पर रहती है।';

  @override
  String get assistantAssistanceOnline =>
      'पथ उपलब्ध होने पर आपातकालीन जानकारी भेजी जा सकती है।';

  @override
  String get assistantPacketPresent => 'इस उपकरण पर एक आपातकालीन घटना दर्ज है।';

  @override
  String get assistantPacketAbsent =>
      'अभी कोई आपातकालीन सहायता अनुरोध दर्ज नहीं है।';

  @override
  String get assistantConfirmSafe =>
      'कृपया पुष्टि करें कि आप सुरक्षित हैं या नहीं।';

  @override
  String get assistantContextElevated => 'वर्तमान आकलन संदर्भ अधिक भार है।';

  @override
  String get assistantContextExertion => 'वर्तमान आकलन संदर्भ परिश्रम है।';

  @override
  String get assistantContextRest => 'वर्तमान आकलन संदर्भ विश्राम है।';

  @override
  String get assistantNotADiagnosis => 'यह जोखिम आकलन है, चिकित्सा निदान नहीं।';

  @override
  String get assistantHelpPath =>
      'यदि आपको सहायता चाहिए, तो मुझे सहायता चाहिए का उपयोग करके इस उपकरण पर आपातकालीन घटना दर्ज करें।';

  @override
  String assistantGoToPlace(String place) {
    return 'अनुशंसित सुरक्षित स्थान: $place।';
  }

  @override
  String get assistantTechnicalTitle => 'उपकरण पर सहायक';

  @override
  String get assistantTechnicalBody =>
      'सत्र स्थिति, आपदा मार्गदर्शन और स्थान मार्गदर्शन इसी उपकरण पर उपयोग करता है। यह किसी क्लाउड भाषा मॉडल को नहीं बुलाता।';

  @override
  String get disasterNav => 'आपदा';

  @override
  String get survivalNav => 'जीवित रहना';

  @override
  String get devicesNav => 'उपकरण';

  @override
  String get chartNeedsReadings =>
      'इस उपकरण पर हाल की रीडिंग संग्रहित होने के बाद चार्ट दिखेंगे।';

  @override
  String get heartRateTrend => 'हृदय गति प्रवृत्ति';

  @override
  String get activityMix => 'हाल की रीडिंग से गतिविधि मिश्रण';

  @override
  String get officialReports => 'आधिकारिक जानकारी';

  @override
  String get userReports => 'उपयोगकर्ता द्वारा दी गई जानकारी';

  @override
  String get officialReportsHint =>
      'यह इस उपकरण पर एक प्रदर्शन आधिकारिक बाढ़ चेतावनी है। यह जीवित सरकारी फ़ीड नहीं है।';

  @override
  String get noOfficialWarning =>
      'इस उपकरण पर कोई आधिकारिक चेतावनी सक्रिय नहीं है।';

  @override
  String get noUserReports =>
      'इस उपकरण पर कोई उपयोगकर्ता आपातकालीन जानकारी प्राप्त नहीं हुई है।';

  @override
  String get activateOfficialFlood => 'प्रदर्शन बाढ़ चेतावनी सक्रिय करें';

  @override
  String get officialVsUserHint =>
      'आधिकारिक जानकारी इस उपकरण पर समर्थित चेतावनी से आती है। उपयोगकर्ता जानकारी निकटवर्ती PRANA उपयोगकर्ताओं या आपके नोट से आती है।';

  @override
  String get addLocalNote => 'स्थानीय स्थिति नोट जोड़ें';

  @override
  String get localNoteHint =>
      'केवल इस खाते पर संग्रहित। आधिकारिक नहीं, उपयोगकर्ता द्वारा दी गई जानकारी के रूप में चिह्नित।';

  @override
  String get localNoteLabel => 'स्थिति नोट';

  @override
  String get saveLocalNote => 'नोट सहेजें';

  @override
  String get localNotesHeading => 'आपके स्थानीय नोट';

  @override
  String get thisDevice => 'यह उपकरण';

  @override
  String get heartRateAccessory => 'हृदय गति सहायक उपकरण';

  @override
  String get accessoryConnected => 'कनेक्टेड';

  @override
  String get accessoryNotConnected => 'कनेक्ट नहीं';

  @override
  String get accessoryUnsupported => 'इस ब्राउज़र में उपलब्ध नहीं';

  @override
  String get sourceDemonstration => 'प्रदर्शन डेटा';

  @override
  String get sourceLive => 'उपकरण सेंसर';

  @override
  String get emergencyContacts => 'आपातकालीन संपर्क';

  @override
  String get noEmergencyContacts =>
      'इस खाते के लिए कोई आपातकालीन संपर्क सहेजा नहीं गया।';

  @override
  String get addEmergencyContact => 'संपर्क जोड़ें';

  @override
  String get contactName => 'नाम';

  @override
  String get contactPhone => 'फ़ोन';

  @override
  String get removeContact => 'हटाएँ';

  @override
  String get contactsStayLocal =>
      'संपर्क इसी उपकरण पर इसी खाते के लिए रहते हैं। PRANA आपके लिए कॉल नहीं करता।';

  @override
  String greetingNamed(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String usualRange(String low, String high) {
    return 'सामान्य $low–$high';
  }

  @override
  String get comparedWithUsual => 'सामान्य से तुलना';

  @override
  String get withinUsual => 'सामान्य के निकट';

  @override
  String get differsFromUsual => 'सामान्य से भिन्न';

  @override
  String get noBaselineYet => 'अभी कोई सामान्य सीमा नहीं';

  @override
  String get disasterGuidanceHeading => 'सुरक्षा मार्गदर्शन';

  @override
  String get saferPlaceHeading => 'सुरक्षित स्थान';

  @override
  String get survivalTitle => 'आपदा के बाद / जीवित रहना';

  @override
  String get devicesTitle => 'उपकरण और संपर्क';

  @override
  String get baselineTableUsual => 'सामान्य सीमा';

  @override
  String get baselineTableNow => 'अब';
}
