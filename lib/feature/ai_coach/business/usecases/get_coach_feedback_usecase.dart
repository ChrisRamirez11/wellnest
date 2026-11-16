import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';
import 'package:wellnest/feature/ai_coach/business/repositories/ai_coach_repository.dart';

class GetCoachFeedbackUseCase {
  final AiCoachRepository repository;

  GetCoachFeedbackUseCase(this.repository);

  Future<AiCoachResponse> call(AiCoachPrompt prompt) {
    return repository.getCoachFeedback(prompt: prompt);
  }
}
