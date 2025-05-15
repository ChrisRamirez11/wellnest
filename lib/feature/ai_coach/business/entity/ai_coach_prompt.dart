class AiCoachPrompt {
  final String userId;
  final String userMessage;
  final String language;
  final String? summary;
  final String? period;
  final String? previousResponseId;

  AiCoachPrompt({
    required this.userId,
    required this.userMessage,
    required this.language,
    this.summary,
    this.period,
    this.previousResponseId,
  });
}
