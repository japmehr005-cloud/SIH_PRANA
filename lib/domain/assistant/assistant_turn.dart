final class AssistantTurn {
  const AssistantTurn({
    required this.question,
    required this.headline,
    required this.lines,
    required this.askedAt,
  });

  final String question;
  final String headline;
  final List<String> lines;
  final DateTime askedAt;

  Map<String, Object?> toJson() {
    return {
      'question': question,
      'headline': headline,
      'lines': lines,
      'askedAt': askedAt.toIso8601String(),
    };
  }

  factory AssistantTurn.fromJson(Map<String, Object?> json) {
    return AssistantTurn(
      question: json['question'] as String? ?? '',
      headline: json['headline'] as String? ?? '',
      lines: [
        for (final line in json['lines'] as List<dynamic>? ?? const [])
          '$line',
      ],
      askedAt:
          DateTime.tryParse(json['askedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
