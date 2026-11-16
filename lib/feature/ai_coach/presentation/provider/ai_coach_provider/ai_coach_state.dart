import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';
import 'package:wellnest/feature/ai_coach/business/entity/chat_message_entity.dart';

class AiCoachState {
  final bool loading;
  final AiCoachResponse? data;
  final String? error;
  final List<ChatMessage> history;

  AiCoachState(
      {this.loading = false, this.data, this.error, this.history = const []});

  AiCoachState copyWith(
          {bool? loading,
          AiCoachResponse? data,
          String? error,
          List<ChatMessage>? history}) =>
      AiCoachState(
          loading: loading ?? this.loading,
          data: data ?? this.data,
          error: error,
          history: history ?? this.history);
}
