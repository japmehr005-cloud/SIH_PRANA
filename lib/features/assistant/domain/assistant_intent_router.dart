import 'package:aarogya/domain/assistant/assistant_intent.dart';
import 'package:aarogya/l10n/app_localizations.dart';

/// Keyword router over trusted phrases. Never infers a fall or disaster.
abstract final class AssistantIntentRouter {
  static AssistantIntentMatch route(String raw, {AppLocalizations? l10n}) {
    final text = _normalize(raw);
    if (text.isEmpty) {
      return const AssistantIntentMatch(intent: AssistantIntent.briefing);
    }

    if (l10n != null) {
      for (final entry in suggestedQuestions(l10n).entries) {
        if (text == _normalize(entry.value)) {
          return AssistantIntentMatch(intent: entry.key);
        }
      }
    }

    for (final entry in _phrases.entries) {
      for (final phrase in entry.value) {
        if (_containsPhrase(text, phrase)) {
          return AssistantIntentMatch(intent: entry.key);
        }
      }
    }

    return const AssistantIntentMatch(
      intent: AssistantIntent.briefing,
      unrecognized: true,
    );
  }

  static Map<AssistantIntent, String> suggestedQuestions(AppLocalizations l10n) {
    return {
      AssistantIntent.whyStatusChanged: l10n.assistantQuestionWhyStatus,
      AssistantIntent.whatChangedFromUsual: l10n.assistantQuestionWhatChanged,
      AssistantIntent.amIOkay: l10n.assistantQuestionAmIOkay,
      AssistantIntent.whatShouldIDo: l10n.assistantQuestionWhatShouldIDo,
      AssistantIntent.whereToGo: l10n.assistantQuestionWhereToGo,
      AssistantIntent.whatIfINeedHelp: l10n.assistantQuestionWhatIfHelp,
      AssistantIntent.emergencyWhatToDo: l10n.assistantQuestionEmergency,
      AssistantIntent.whyAlerted: l10n.assistantQuestionWhyAlerted,
    };
  }

  static List<AssistantIntent> chipOrder({required bool emergencyFirst}) {
    if (emergencyFirst) {
      return const [
        AssistantIntent.whatShouldIDo,
        AssistantIntent.whereToGo,
        AssistantIntent.whatIfINeedHelp,
        AssistantIntent.whyStatusChanged,
        AssistantIntent.whatChangedFromUsual,
      ];
    }
    return const [
      AssistantIntent.whyStatusChanged,
      AssistantIntent.whatChangedFromUsual,
      AssistantIntent.amIOkay,
      AssistantIntent.whatShouldIDo,
      AssistantIntent.whereToGo,
      AssistantIntent.whatIfINeedHelp,
    ];
  }

  static String _normalize(String raw) {
    return raw.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool _containsPhrase(String text, String phrase) {
    final normalized = _normalize(phrase);
    if (normalized.isEmpty) {
      return false;
    }
    if (text == normalized) {
      return true;
    }
    if (normalized.length <= 4) {
      return RegExp('\\b${RegExp.escape(normalized)}\\b').hasMatch(text);
    }
    return text.contains(normalized);
  }
}

const _phrases = <AssistantIntent, List<String>>{
  AssistantIntent.emergencyWhatToDo: [
    'what should i do in this emergency',
    'what should i do during the emergency',
    'during the emergency',
    'in this emergency',
    'this emergency',
    'emergency what to do',
    'इस आपातकाल में मुझे क्या करना चाहिए',
    'इस आपातकाल',
    'आपातकाल में',
  ],
  AssistantIntent.whyAlerted: [
    'why did prana alert me',
    'why was i alerted',
    'why alerted',
    'why the alert',
    'why warning',
    'why notified',
    'why did i get an alert',
    'मुझे चेतावनी क्यों मिली',
    'चेतावनी क्यों',
    'अलर्ट क्यों',
  ],
  AssistantIntent.whyStatusChanged: [
    'why did my health status change',
    'why did my status change',
    'why is my status elevated',
    'why is my heart rate high',
    'why is heart rate high',
    'why status changed',
    'status change',
    'why my status',
    'heart rate high',
    'मेरी स्थिति क्यों बदली',
    'स्थिति क्यों बदली',
    'हृदय गति अधिक क्यों',
  ],
  AssistantIntent.usualReadings: [
    'what is my normal heart rate',
    'what is my usual heart rate',
    'my normal heart rate',
    'usual heart rate',
    'normal heart rate',
    'what is my baseline',
    'मेरी सामान्य हृदय गति',
    'सामान्य हृदय गति क्या',
  ],
  AssistantIntent.whatChangedFromUsual: [
    'what changed from my usual readings',
    'what changed from my usual',
    'what changed from usual',
    'changed from usual',
    'usual readings',
    'from my usual',
    'what changed',
    'मेरी सामान्य रीडिंग से क्या बदला',
    'सामान्य रीडिंग',
  ],
  AssistantIntent.whatIfINeedHelp: [
    'how can i get help',
    'what if i need help',
    'if i need help',
    'need help',
    'how do i get help',
    'यदि मुझे सहायता चाहिए तो क्या करूँ',
    'यदि मुझे सहायता',
    'सहायता कैसे',
  ],
  AssistantIntent.whereToGo: [
    'where should i go',
    'where to go',
    'safer location',
    'safer place',
    'where should i',
    'मुझे कहाँ जाना चाहिए',
    'कहाँ जाना चाहिए',
    'कहां जाना चाहिए',
    'सुरक्षित स्थान',
  ],
  AssistantIntent.amIOkay: [
    'am i okay',
    'am i ok',
    'am i safe',
    'how am i',
    'क्या मैं ठीक हूँ',
    'क्या मैं ठीक हूं',
    'क्या मैं सुरक्षित हूँ',
    'क्या मैं सुरक्षित हूं',
  ],
  AssistantIntent.whatShouldIDo: [
    'what should i do',
    'what do i do',
    'next action',
    'मुझे क्या करना चाहिए',
    'क्या करना चाहिए',
    'क्या करूँ',
    'क्या करूं',
  ],
};
