import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/usecases/get_coach_feedback_usecase.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_state.dart';

import '../../business/entity/chat_message_entity.dart';

class AiCoachNotifier extends StateNotifier<AiCoachState> {
  final GetCoachFeedbackUseCase useCase;

  AiCoachNotifier(this.useCase) : super(AiCoachState());

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

      state = state.copyWith(history: updated);

      state = state.copyWith(loading: false, data: response);
    } on ServerException catch (e){
      state = state.copyWith(loading: false, error: e.message);
    }
    catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
