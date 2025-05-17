import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';
import 'package:wellnest/feature/ai_coach/business/entity/token_stats.dart';
import 'package:wellnest/feature/ai_coach/data/models/token_stats_model.dart';

import '../../business/repositories/ai_coach_repository.dart';
import '../datasources/ai_coach_remote_datasource.dart';
import '../models/ai_coach_prompt_model.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
  final AiCoachRemoteDatasource datasource;

  AiCoachRepositoryImpl(this.datasource);

  @override
  Future<AiCoachResponse> getCoachFeedback(
      {required AiCoachPrompt prompt}) async {
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

  @override
  Future<TokenStats> getTokenStats() async {
    final model = await fetchTokenStats();
    return model.toEntity();
  }

  Future<TokenStatsModel> fetchTokenStats() async {
    final client = Supabase.instance.client;
    try {
      final today = DateTime.now();
      final firstDay = DateTime(today.year, today.month, 1)
          .toIso8601String()
          .substring(0, 10);
      final res = await client
          .from('token_usage')
          .select('input_tokens,output_tokens')
          .eq('user_id', client.auth.currentUser!.id)
          .gte('date', firstDay);

      final records = res as List<dynamic>;
      final total = records.fold<int>(
        0,
        (sum, r) =>
            sum + (r['input_tokens'] as int) + (r['output_tokens'] as int),
      );

      return TokenStatsModel(
        used: total,
        limit: 500000, // or read from config
      );
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch token stats: \$e');
    }
  }
}
