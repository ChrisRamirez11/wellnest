import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_response.dart';
import 'package:wellnest/feature/ai_coach/business/usecases/get_coach_feedback_usecase.dart';
import 'package:wellnest/feature/ai_coach/business/usecases/token_stats_usecase.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/ai_coach_state.dart';

import '../../../business/entity/chat_message_entity.dart';

class AiCoachNotifier extends StateNotifier<AiCoachState> {
  final GetCoachFeedbackUseCase useCase;
  final GetTokenStatsUseCase statsUc;

  AiCoachNotifier(this.useCase, this.statsUc) : super(AiCoachState()) {
    _loadInitialStats();
  }

  Future<void> _loadInitialStats() async {
    try {
      final stats = await statsUc();
      // we reuse the same state.data but just populate the stats fields
      state = state.copyWith(
          data: AiCoachResponse(
        response: state.data?.response ?? '',
        previousResponseId: state.data?.previousResponseId,
        tokensUsedThisMonth: stats.usedThisMonth,
        monthlyTokenLimit: stats.monthlyLimit,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchCoachFeedback(AiCoachPrompt prompt) async {
    state = state.copyWith(loading: true, error: null);
    // 1. Añadimos el mensaje del usuario
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: prompt.userMessage,
      author: Author.user,
    );
    state = state.copyWith(history: [...state.history, userMsg], error: null);

    // 2. Añadimos un “placeholder” loading para la respuesta
    final placeholder = ChatMessage(
      id: 'loading',
      text: '',
      author: Author.bot,
      isLoading: true,
    );
    state = state.copyWith(history: [...state.history, placeholder]);

    try {
      final response = await useCase(prompt);

      // 3. Reemplazamos el placeholder por el mensaje real
      final updated = state.history.map((m) {
        if (m.id == 'loading') {
          return ChatMessage(
            id: response.previousResponseId ?? DateTime.now().toString(),
            text: response.response,
            author: Author.bot,
            isLoading: false,
          );
        }
        return m;
      }).toList();

      state = state.copyWith(history: updated, loading: false, data: response);
    } on ServerException catch (e) {
      state.history.removeWhere(
        (element) => element.id == 'loading',
      );

      state = state.copyWith(
        loading: false,
        error: e.message,
      );
    } catch (e) {
      state.history.removeWhere(
        (element) => element.id == 'loading',
      );

      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
