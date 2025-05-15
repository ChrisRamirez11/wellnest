import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/chat_message_entity.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/providers.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_bubble.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_text_box.dart';
import 'package:wellnest/main.dart';

class CoachChatScreen extends ConsumerWidget {
  const CoachChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el estado
    final state = ref.watch(aiCoachNotifierProvider);
    final notifier = ref.read(aiCoachNotifierProvider.notifier);

    // Extraemos el uso de tokens (o damos valores por defecto si aún no hay datos)
    final used = state.data?.tokensUsedThisMonth.toDouble() ?? 0.0;
    final limit = state.data?.monthlyTokenLimit.toDouble() ?? 10000.0;

    final language = ref.watch(localeProvider).locale;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SizedBox(
          width: 150,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mostramos en miles (K) si quieres
                  Text(
                    '${(used / 1000).toStringAsFixed(1)}K - ${(limit / 1000).toStringAsFixed(1)}K',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${(limit > 0 ? (used / limit * 100) : 0).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: limit > 0 ? used / limit : 0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 4,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.history.length,
              itemBuilder: (_, i) {
                final msg = state.history[i];
                return ChatBubble(
                  text: msg.text,
                  isUser: msg.author == Author.user,
                  isLoading: msg.isLoading,
                );
              },
            ),
          ),
          if (state.error != null)
            Text('Error: ${state.error}',
                style: const TextStyle(color: Colors.red)),
          ChatTextBox(
            onSubmitted: (message, period) async {
              final prompt = AiCoachPrompt(
                userId: supabase.auth.currentUser!.id,
                userMessage: message,
                language: language?.languageCode ??
                    PlatformDispatcher.instance.locale.languageCode,
                summary: null,
                period: period == TimeRange.none
                    ? null
                    : (period == TimeRange.weekData ? 'week' : 'month'),
                previousResponseId: state.data?.previousResponseId,
              );
              await notifier.fetchCoachFeedback(prompt);
            },
          ),
        ],
      ),
    );
  }
}
