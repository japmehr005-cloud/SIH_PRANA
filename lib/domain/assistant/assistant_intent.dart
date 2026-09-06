enum AssistantIntent {
  whyStatusChanged,
  whatChangedFromUsual,
  amIOkay,
  whatShouldIDo,
  whereToGo,
  whatIfINeedHelp,
  emergencyWhatToDo,
  whyAlerted,
  usualReadings,
  briefing,
}

final class AssistantIntentMatch {
  const AssistantIntentMatch({
    required this.intent,
    this.unrecognized = false,
  });

  final AssistantIntent intent;
  final bool unrecognized;
}
