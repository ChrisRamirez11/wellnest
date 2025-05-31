// ai_coach/business/entity/ai_coach_response.dart

class AiCoachResponse {
  final String response;
  final String? previousResponseId;

  /// Input tokens used this month
  final int inputUsedThisMonth;

  /// Output tokens used this month
  final int outputUsedThisMonth;

  /// Monthly limit of input tokens
  final int inputMonthlyLimit;

  /// Monthly limit of output tokens
  final int outputMonthlyLimit;

  const AiCoachResponse({
    required this.response,
    this.previousResponseId,
    required this.inputUsedThisMonth,
    required this.outputUsedThisMonth,
    required this.inputMonthlyLimit,
    required this.outputMonthlyLimit,
  });
}
