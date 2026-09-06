import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/domain/assistant/assistant_intent.dart';
import 'package:aarogya/domain/assistant/assistant_reply.dart';
import 'package:aarogya/domain/assistant/assistant_situation.dart';
import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/risk/risk_reason.dart';
import 'package:aarogya/features/disaster/domain/disaster_guidance.dart';
import 'package:aarogya/l10n/app_localizations.dart';

abstract final class AssistantComposer {
  static AssistantReply compose({
    required AssistantIntent intent,
    required AssistantSituation situation,
    required AppLocalizations l10n,
    bool unrecognized = false,
  }) {
    final lines = <String>[];
    final fallAwaiting =
        situation.fallStatus == FallStatus.awaitingConfirmation;
    if (unrecognized) {
      _add(lines, l10n.assistantInsufficient);
      _add(lines, l10n.assistantCanHelpWith);
      if (fallAwaiting) {
        _add(lines, l10n.assistantFallExplain);
        _add(lines, l10n.assistantConfirmSafe);
      }
      if (situation.usesDemonstrationData) {
        _add(lines, l10n.assistantDemonstrationNote);
      }
      return AssistantReply(
        headline: _headline(situation, l10n, fallAwaiting),
        lines: lines,
        priority: _priority(situation, fallAwaiting),
        showFallActions: fallAwaiting,
        usesDemonstrationData: situation.usesDemonstrationData,
      );
    }
    if (fallAwaiting) {
      _add(lines, l10n.assistantFallExplain);
      _add(lines, l10n.assistantConfirmSafe);
    }

    switch (intent) {
      case AssistantIntent.whatChangedFromUsual:
        _addHealthChange(lines, situation, l10n);
      case AssistantIntent.amIOkay:
        _addHealthChange(lines, situation, l10n);
        if (situation.riskElevated) {
          _add(lines, l10n.readingsDifferFromBaseline);
        }
        if (!situation.riskElevated &&
            !situation.heartRateHigherThanUsual &&
            !situation.spo2LowerThanUsual &&
            situation.fallStatus == FallStatus.none) {
          _add(lines, l10n.assistantReadingsClose);
        }
        _add(lines, l10n.assistantNotADiagnosis);
      case AssistantIntent.whyStatusChanged:
      case AssistantIntent.whyAlerted:
        _addWhy(lines, situation, l10n);
      case AssistantIntent.whatShouldIDo:
      case AssistantIntent.emergencyWhatToDo:
        _addActions(lines, situation, l10n);
      case AssistantIntent.whereToGo:
        _addWhere(lines, situation, l10n);
      case AssistantIntent.whatIfINeedHelp:
        _addHelp(lines, situation, l10n);
      case AssistantIntent.usualReadings:
        _addUsualReadings(lines, situation, l10n);
      case AssistantIntent.briefing:
        _addBriefing(lines, situation, l10n);
    }

    if (situation.usesDemonstrationData) {
      _add(lines, l10n.assistantDemonstrationNote);
    }

    return AssistantReply(
      headline: _headline(situation, l10n, fallAwaiting),
      lines: lines,
      priority: _priority(situation, fallAwaiting),
      showFallActions: fallAwaiting,
      usesDemonstrationData: situation.usesDemonstrationData,
    );
  }

  static AssistantReplyPriority _priority(
    AssistantSituation situation,
    bool fallAwaiting,
  ) {
    if (fallAwaiting) {
      return AssistantReplyPriority.fall;
    }
    if (situation.phase.isEmergencyActive || situation.packetPresent) {
      return AssistantReplyPriority.emergency;
    }
    return AssistantReplyPriority.health;
  }

  static String _headline(
    AssistantSituation situation,
    AppLocalizations l10n,
    bool fallAwaiting,
  ) {
    if (fallAwaiting) {
      return l10n.assistantHeadlineFall;
    }
    if (situation.phase.isEmergencyActive || situation.packetPresent) {
      return l10n.assistantHeadlineEmergency;
    }
    return l10n.assistantHeadlineHealth;
  }

  static void _addHealthChange(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    if (situation.baselineNotReady) {
      _add(lines, l10n.assistantBaselineNotReady);
    }
    if (situation.currentHeartRate == null && situation.currentSpo2 == null) {
      _add(lines, l10n.assistantReadingsUnavailable);
      return;
    }
    if (situation.heartRateHigherThanUsual) {
      _add(lines, l10n.assistantHrHigherUsual);
      if (situation.contextLabel == 'elevated_load' ||
          situation.contextLabel == 'exertion') {
        _add(lines, l10n.assistantRestAndRecheck);
      }
    } else if (situation.heartRateLowerThanUsual) {
      _add(lines, l10n.assistantHrLowerUsual);
    } else if (situation.currentHeartRate != null &&
        situation.usualHeartRate != null) {
      _add(lines, l10n.assistantHrSimilarUsual);
    }
    if (situation.currentHeartRate != null &&
        situation.usualHeartRate != null) {
      _add(
        lines,
        l10n.alertHrVsBaseline(
          situation.currentHeartRate!.toStringAsFixed(0),
          situation.usualHeartRate!.toStringAsFixed(0),
        ),
      );
    }
    if (situation.spo2LowerThanUsual) {
      _add(lines, l10n.assistantSpo2LowerUsual);
    } else if (situation.currentSpo2 != null && situation.usualSpo2 != null) {
      _add(lines, l10n.assistantSpo2SimilarUsual);
    }
    if (situation.currentSpo2 != null && situation.usualSpo2 != null) {
      _add(
        lines,
        l10n.alertSpo2VsBaseline(
          situation.currentSpo2!.toStringAsFixed(0),
          situation.usualSpo2!.toStringAsFixed(0),
        ),
      );
    }
    _addContext(lines, situation, l10n);
  }

  static void _addContext(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    switch (situation.contextLabel) {
      case 'elevated_load':
        _add(lines, l10n.assistantContextElevated);
      case 'exertion':
        _add(lines, l10n.assistantContextExertion);
      case 'rest':
        _add(lines, l10n.assistantContextRest);
    }
  }

  static void _addWhy(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    if (!situation.noDisasterActive) {
      if (situation.disasterType == DisasterType.flood) {
        _add(lines, l10n.floodWarningIssued);
      }
      if (situation.disasterType != null) {
        _add(
          lines,
          l10n.assistantDisasterLine(disasterLabel(l10n, situation.disasterType)),
        );
      }
    } else if (situation.fallStatus == FallStatus.none &&
        !situation.riskElevated) {
      _add(lines, l10n.assistantSituationLine(phaseLabel(l10n, situation.phase)));
    }
    if (situation.riskElevated) {
      _add(lines, l10n.readingsDifferFromBaseline);
    }
    _addHealthChange(lines, situation, l10n);
    for (final reason in situation.riskReasons) {
      if (reason == RiskReasonCode.possibleFallSequence &&
          situation.fallStatus == FallStatus.none) {
        continue;
      }
      if (reason == RiskReasonCode.hrAboveBaseline ||
          reason == RiskReasonCode.spo2BelowBaseline ||
          reason == RiskReasonCode.modelElevatedLoadContext ||
          reason == RiskReasonCode.modelExertionContext) {
        _add(lines, reasonLabel(l10n, reason));
      }
    }
  }

  static void _addActions(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    if (situation.noDisasterActive && !situation.phase.isEmergencyActive) {
      _add(lines, l10n.assistantNoDisaster);
      if (situation.riskElevated) {
        _add(lines, l10n.readingsDifferFromBaseline);
      }
      _add(
        lines,
        l10n.assistantSituationLine(phaseLabel(l10n, situation.phase)),
      );
      if (situation.connectivityLimited) {
        _add(lines, l10n.assistantOfflineLocal);
      }
      return;
    }

    _add(lines, l10n.assistantEmergencyAttention);
    _add(lines, l10n.assistantSituationLine(phaseLabel(l10n, situation.phase)));
    if (situation.disasterType == DisasterType.flood) {
      _add(lines, l10n.floodWarningIssued);
    } else if (situation.disasterType != null) {
      _add(
        lines,
        l10n.assistantDisasterLine(disasterLabel(l10n, situation.disasterType)),
      );
    }
    for (final code in DisasterGuidanceCatalog.forType(
      situation.disasterType,
    ).take(3)) {
      _add(lines, guidanceLabel(l10n, code));
    }
    if (situation.hasGuidance) {
      _add(lines, l10n.assistantGoToPlace(situation.placeLabel!));
      _add(
        lines,
        l10n.distanceAndBearing(
          situation.distanceMeters!.toStringAsFixed(0),
          situation.compassLabel!,
        ),
      );
    }
    _add(
      lines,
      situation.connectivityLimited
          ? l10n.assistantAssistanceLimited
          : l10n.assistantAssistanceOnline,
    );
  }

  static void _addWhere(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    if (!situation.hasGuidance) {
      _add(lines, l10n.assistantNoSaferPlace);
      return;
    }
    _add(
      lines,
      l10n.assistantSaferPlaceApprox(
        situation.placeLabel!,
        situation.distanceMeters!.toStringAsFixed(0),
        compassWord(l10n, situation.compassLabel!),
      ),
    );
  }

  static void _addUsualReadings(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    if (situation.baselineNotReady || situation.usualHeartRate == null) {
      _add(lines, l10n.assistantBaselineNotReady);
      return;
    }
    _add(
      lines,
      l10n.assistantUsualHr(situation.usualHeartRate!.toStringAsFixed(0)),
    );
    if (situation.usualSpo2 != null) {
      _add(
        lines,
        l10n.alertSpo2VsBaseline(
          situation.currentSpo2?.toStringAsFixed(0) ?? l10n.unavailable,
          situation.usualSpo2!.toStringAsFixed(0),
        ),
      );
    }
  }

  static void _addHelp(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    _add(lines, l10n.assistantHelpPath);
    if (situation.packetPresent) {
      _add(lines, l10n.assistantPacketPresent);
      if (situation.packetEventType != null) {
        _add(lines, eventTypeLabel(l10n, situation.packetEventType!));
      }
    } else {
      _add(lines, l10n.assistantPacketAbsent);
    }
    _add(
      lines,
      situation.connectivityLimited
          ? l10n.assistantAssistanceLimited
          : l10n.assistantAssistanceOnline,
    );
    if (situation.nearbyCount > 0) {
      _add(lines, l10n.assistantNearbyPresent);
    }
    if (situation.connectivityLimited) {
      _add(lines, l10n.assistantOfflineLocal);
    }
  }

  static void _addBriefing(
    List<String> lines,
    AssistantSituation situation,
    AppLocalizations l10n,
  ) {
    _add(lines, l10n.assistantSituationLine(phaseLabel(l10n, situation.phase)));
    if (!situation.noDisasterActive &&
        situation.disasterType == DisasterType.flood) {
      _add(lines, l10n.floodWarningIssued);
    }
    if (situation.baselineNotReady) {
      _add(lines, l10n.assistantBaselineNotReady);
    }
    if (situation.heartRateHigherThanUsual) {
      _add(lines, l10n.assistantHrHigherUsual);
    } else if (situation.heartRateMatchesUsual) {
      _add(lines, l10n.assistantHrSimilarUsual);
    }
    if (situation.riskElevated) {
      _add(lines, l10n.readingsDifferFromBaseline);
    }
    if (situation.hasGuidance) {
      _add(lines, l10n.assistantGoToPlace(situation.placeLabel!));
    } else if (situation.locationUnknown && situation.phase.isEmergencyActive) {
      _add(lines, l10n.assistantLocationUnavailable);
    }
    if (situation.packetPresent) {
      _add(lines, l10n.assistantPacketPresent);
    }
  }

  static void _add(List<String> lines, String line) {
    if (line.trim().isEmpty || lines.contains(line)) {
      return;
    }
    lines.add(line);
  }
}
