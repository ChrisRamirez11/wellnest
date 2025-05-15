class AiCoachPromptModel {
  final String userId;
  final String userMessage;
  final String language;
  final String? summary;
  final String? period;
  final String? previousResponseId;

  AiCoachPromptModel({
    required this.userId,
    required this.userMessage,
    required this.language,
    this.summary,
    this.period,
    this.previousResponseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_message': userMessage,
      'language': language,
      if (summary != null) 'summary': summary,
      if (period != null) 'period': period,
      if (previousResponseId != null) 'previous_response_id': previousResponseId,
    };
  }
}