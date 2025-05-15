class AiCoachResponse {
  final String response;
  final String? previousResponseId;
  final int tokensUsedThisMonth;
  final int monthlyTokenLimit;

  AiCoachResponse({
    required this.response,
    this.previousResponseId,
    required this.tokensUsedThisMonth,
    required this.monthlyTokenLimit,
  });
}
