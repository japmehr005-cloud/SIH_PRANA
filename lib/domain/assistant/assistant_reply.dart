enum AssistantReplyPriority { health, emergency, fall }

final class AssistantReply {
  const AssistantReply({
    required this.headline,
    required this.lines,
    required this.priority,
    this.showFallActions = false,
    this.usesDemonstrationData = false,
  });

  final String headline;
  final List<String> lines;
  final AssistantReplyPriority priority;
  final bool showFallActions;
  final bool usesDemonstrationData;
}
