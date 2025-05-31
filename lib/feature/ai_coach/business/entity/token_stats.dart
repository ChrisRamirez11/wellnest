// ai_coach/business/entity/token_stats.dart

class TokenStats {
  /// Amount of input tokens used this month
  final int inputUsedThisMonth;

  /// Amount of output tokens used this month
  final int outputUsedThisMonth;

  /// Monthly limit for input tokens (e.g., 5_000_000)
  final int inputMonthlyLimit;

  /// Monthly limit for output tokens (e.g., 1_000_000)
  final int outputMonthlyLimit;

  const TokenStats({
    required this.inputUsedThisMonth,
    required this.outputUsedThisMonth,
    required this.inputMonthlyLimit,
    required this.outputMonthlyLimit,
  });
}
