import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';
import 'package:wellnest/feature/ai_coach/business/entity/token_stats.dart';

abstract class AiCoachRepository {
  Future<AiCoachResponse> getCoachFeedback({
    required AiCoachPrompt prompt,
  });

  Future<TokenStats> getTokenStats();
}