import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';

abstract class AiCoachRepository {
  Future<AiCoachResponse> getCoachFeedback({
    required AiCoachPrompt prompt,
  });
}