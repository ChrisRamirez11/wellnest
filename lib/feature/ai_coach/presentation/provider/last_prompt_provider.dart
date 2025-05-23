import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';

final lastPromptProvider = StateProvider<AiCoachPrompt>(
  (ref) => AiCoachPrompt(
      userId: '',
      userMessage: '',
      language: '',
      period: '',
      previousResponseId: '',
      summary: ''),
);
