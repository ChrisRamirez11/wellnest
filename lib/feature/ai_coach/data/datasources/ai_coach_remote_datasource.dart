import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/ai_coach/data/models/ai_coach_prompt_model.dart';
import 'package:wellnest/feature/ai_coach/data/models/ai_coach_response_model.dart';
import 'package:wellnest/feature/ai_coach/data/models/token_stats_model.dart';

abstract class AiCoachRemoteDatasource {
  Future<AiCoachResponseModel> fetchCoachResponse(AiCoachPromptModel prompt);
  Future<TokenStatsModel> fetchTokenStats();
}

class AiCoachRemoteDatasourceImpl implements AiCoachRemoteDatasource {
  final SupabaseClient client;

  AiCoachRemoteDatasourceImpl(this.client);

  @override
  Future<AiCoachResponseModel> fetchCoachResponse(
      AiCoachPromptModel prompt) async {
    try {
      final response = await client.functions.invoke(
        'lifestyle-coach',
        body: prompt.toJson(),
      );
      if (response.status < 200 || response.status >= 300) {
        throw ServerException(
            message: 'Error ${response.status}: ${response.data}');
      }
      return AiCoachResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on FunctionException catch (e) {
      throw ServerException(message: e.details['error']);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch coach response');
    }
  }

  @override
  Future<TokenStatsModel> fetchTokenStats() async {
    try {
      final today = DateTime.now();
      final firstDayOfMonth = DateTime(today.year, today.month, 1)
          .toIso8601String()
          .substring(0, 10);

      // Fetch all registers from token_usage since month's first day
      final response = await client
          .from('token_usage')
          .select('input_tokens, output_tokens')
          .gte('date', firstDayOfMonth)
          .eq('user_id', client.auth.currentUser!.id);

      // response is a List<Map<String, dynamic>>
      final records = response as List<dynamic>;

      int inputTotal = 0;
      int outputTotal = 0;

      for (final r in records) {
        inputTotal += (r['input_tokens'] as int);
        outputTotal += (r['output_tokens'] as int);
      }

      return TokenStatsModel(
        inputUsed: inputTotal,
        outputUsed: outputTotal,
        // wished límits:
        inputLimit: 5000000,
        outputLimit: 1000000,
      );
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch token stats');
    }
  }
}
