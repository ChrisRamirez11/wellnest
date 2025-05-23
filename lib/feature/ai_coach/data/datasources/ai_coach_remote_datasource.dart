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
      throw ServerException(message: 'Failed to fetch coach response: $e');
    }
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
