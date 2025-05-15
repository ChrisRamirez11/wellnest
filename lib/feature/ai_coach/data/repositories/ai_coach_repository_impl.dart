import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';

import '../../business/repositories/ai_coach_repository.dart';
import '../datasources/ai_coach_remote_datasource.dart';
import '../models/ai_coach_prompt_model.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
  final AiCoachRemoteDatasource datasource;

  AiCoachRepositoryImpl(this.datasource);

  @override
  Future<AiCoachResponse> getCoachFeedback({required AiCoachPrompt prompt}) async {
    final model = AiCoachPromptModel(
      userId: prompt.userId,
      userMessage: prompt.userMessage,
      language: prompt.language,
      summary: prompt.summary,
      period: prompt.period,
      previousResponseId: prompt.previousResponseId,
    );
    final responseModel = await datasource.fetchCoachResponse(model);
    return responseModel.toEntity();
  }
}
