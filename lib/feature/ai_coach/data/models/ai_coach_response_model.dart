import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';

class AiCoachResponseModel {
  final String response;
  final String? previousResponseId;
  final int tokensUsedThisMonth;
  final int monthlyTokenLimit;

  AiCoachResponseModel({
    required this.response,
    this.previousResponseId,
    required this.tokensUsedThisMonth,
    required this.monthlyTokenLimit,
  });

  factory AiCoachResponseModel.fromJson(Map<String, dynamic> json) {
    return AiCoachResponseModel(
      response: json['response'] as String,
      previousResponseId: json['previous_response_id'] as String?,
      tokensUsedThisMonth: json['tokens_used_this_month'] as int,
      monthlyTokenLimit: json['monthly_token_limit'] as int,
    );
  }

  AiCoachResponse toEntity() {
    return AiCoachResponse(
      response: response,
      previousResponseId: previousResponseId,
      tokensUsedThisMonth: tokensUsedThisMonth,
      monthlyTokenLimit: monthlyTokenLimit,
    );
  }
}