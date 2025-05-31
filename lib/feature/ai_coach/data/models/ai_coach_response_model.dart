import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';

class AiCoachResponseModel {
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

  const AiCoachResponseModel({
    required this.response,
    this.previousResponseId,
    required this.inputUsedThisMonth,
    required this.outputUsedThisMonth,
    required this.inputMonthlyLimit,
    required this.outputMonthlyLimit,
  });

  factory AiCoachResponseModel.fromJson(Map<String, dynamic> json) {
    return AiCoachResponseModel(
      response: json['response'] as String,
      previousResponseId: json['previous_response_id'] as String?,
      inputUsedThisMonth: json['input_tokens_used_this_month'] as int,
      outputUsedThisMonth: json['output_tokens_used_this_month'] as int,
      inputMonthlyLimit: json['input_token_limit'] as int,
      outputMonthlyLimit: json['output_token_limit'] as int,
    );
  }

  AiCoachResponse toEntity() {
    return AiCoachResponse(
      response: response,
      previousResponseId: previousResponseId,
      inputUsedThisMonth: inputUsedThisMonth,
      outputUsedThisMonth: outputUsedThisMonth,
      inputMonthlyLimit: inputMonthlyLimit,
      outputMonthlyLimit: outputMonthlyLimit,
    );
  }
}
