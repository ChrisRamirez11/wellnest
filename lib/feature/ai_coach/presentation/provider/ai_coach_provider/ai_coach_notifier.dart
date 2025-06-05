// ai_coach/presentation/provider/ai_coach_provider/ai_coach_notifier.dart
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
    loadInitialStats();
  }

  /// Initial load of stats to show before the first interaction.
  /// Builds an "empty" AiCoachResponse with only token values.
  Future<void> loadInitialStats() async {
    try {
      final stats = await statsUc();

      state = state.copyWith(
        data: AiCoachResponse(
          // No Axio response yet, so leave the text empty:
          response: '',
          previousResponseId: null,

          // Assign the four fields coming from TokenStats:
          inputUsedThisMonth: stats.inputUsedThisMonth,
          outputUsedThisMonth: stats.outputUsedThisMonth,
          inputMonthlyLimit: stats.inputMonthlyLimit,
          outputMonthlyLimit: stats.outputMonthlyLimit,
        ),
      );
    } catch (e) {
      // Debug only: if it fails, don't crash the app, just print the error.
      debugPrint('Error loading initial stats: $e');
    }
  }

  /// Sends the user's prompt to Axio, manages placeholder, and updates state.
  Future<void> fetchCoachFeedback(AiCoachPrompt prompt) async {
    state = state.copyWith(loading: true, error: null);

    // 1) Add user message to the chat history
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: prompt.userMessage,
      author: Author.user,
    );
    state = state.copyWith(
      history: [...state.history, userMsg],
      error: null,
    );

    // 2) Add a "loading" placeholder for the Axio response
    final placeholder = ChatMessage(
      id: 'loading',
      text: '',
      author: Author.bot,
      isLoading: true,
    );
    state = state.copyWith(history: [...state.history, placeholder]);

    try {
      // 3) Call the use case that invokes the backend and returns AiCoachResponse
      final AiCoachResponse response = await useCase(prompt);

      // 4) Replace the placeholder with the real response (including stats)
      final updatedHistory = state.history.map((m) {
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

      // 5) Update state: set loading to false and save the full response
      state = state.copyWith(
        history: updatedHistory,
        loading: false,
        data: response,
      );
    } on ServerException catch (e) {
      // If the server fails, remove the placeholder and show the error
      state = state.copyWith(
        history: state.history.where((m) => m.id != 'loading').toList(),
        loading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        history: state.history.where((m) => m.id != 'loading').toList(),
        loading: false,
        error: e.toString(),
      );
    }
  }
}
