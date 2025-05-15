import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/ai_coach/data/models/ai_coach_prompt_model.dart';
import 'package:wellnest/feature/ai_coach/data/models/ai_coach_response_model.dart';

abstract class AiCoachRemoteDatasource {
  Future<AiCoachResponseModel> fetchCoachResponse(AiCoachPromptModel prompt);
}

class AiCoachRemoteDatasourceImpl implements AiCoachRemoteDatasource {
  final SupabaseClient client;

  AiCoachRemoteDatasourceImpl(this.client);

  @override
  Future<AiCoachResponseModel> fetchCoachResponse(AiCoachPromptModel prompt) async {
    try {
      final response = await client.functions.invoke(
        'lifestyle-coach',
        body: prompt.toJson(),
      );
      if (response.status < 200 || response.status >= 300) {
        throw ServerException(message: 'Error ${response.status}: ${response.data}');
      }
      return AiCoachResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch coach response: $e');
    }
  }
}