// ai_coach/data/models/token_stats_model.dart

import '../../business/entity/token_stats.dart';

class TokenStatsModel {
  /// Input tokens used this month (from backend response)
  final int inputUsed;

  /// Output tokens used this month (from backend response)
  final int outputUsed;

  /// Monthly limit for input tokens (e.g. 5_000_000)
  final int inputLimit;

  /// Monthly limit for output tokens (e.g. 1_000_000)
  final int outputLimit;

  const TokenStatsModel({
    required this.inputUsed,
    required this.outputUsed,
    required this.inputLimit,
    required this.outputLimit,
  });

  /// Converts JSON from the server into this model.
  factory TokenStatsModel.fromJson(Map<String, dynamic> json) {
    return TokenStatsModel(
      inputUsed: json['input_tokens_used_this_month'] as int,
      outputUsed: json['output_tokens_used_this_month'] as int,
      inputLimit: json['input_token_limit'] as int,
      outputLimit: json['output_token_limit'] as int,
    );
  }

  /// Maps this model to the business entity.
  TokenStats toEntity() {
    return TokenStats(
      inputUsedThisMonth: inputUsed,
      outputUsedThisMonth: outputUsed,
      inputMonthlyLimit: inputLimit,
      outputMonthlyLimit: outputLimit,
    );
  }
}
