import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/chat_message_entity.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/period_data_provider/period_data_notifier.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/providers.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/seleted_time_range_provider.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_bubble.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_text_box.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/tokens_usage_widget.dart';
import 'package:wellnest/main.dart';

class CoachChatScreen extends ConsumerStatefulWidget {
  const CoachChatScreen({super.key});

  @override
  ConsumerState<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends ConsumerState<CoachChatScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant CoachChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom(); // in case of updates
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCoachNotifierProvider);
    final notifier = ref.read(aiCoachNotifierProvider.notifier);
    final selectedTimeRange = ref.watch(selectedTimeRangeProvider);
    final language = ref.watch(localeProvider).locale;

    final used = state.data?.tokensUsedThisMonth.toDouble() ?? 0.0;
    final limit = state.data?.monthlyTokenLimit.toDouble() ?? 500000.0;

    // Scroll to bottom when chat history changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SizedBox(width: 150, child: TokensUsageWidget()),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Token usage"),
                  content: Text(
                    "You've used ${used.toStringAsFixed(0)} out of ${limit.toStringAsFixed(0)} tokens available this month. Usage resets on the 1st of each month.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(state.error!, style: const TextStyle(color: Colors.red)),
            ),
          ChatTextBox(
            onSubmitted: (message, period) async {
              await ref.read(periodDataNotifierProvider.notifier).generateSummary(selectedTimeRange);

              final prompt = AiCoachPrompt(
                userId: supabase.auth.currentUser!.id,
                userMessage: message,
                language: language?.languageCode ?? PlatformDispatcher.instance.locale.languageCode,
                summary: ref.watch(periodDataNotifierProvider).summary,
                period: period == TimeRange.none
                    ? null
                    : (period == TimeRange.weekData ? 'week' : 'month'),
                previousResponseId: state.data?.previousResponseId,
              );

              await notifier.fetchCoachFeedback(prompt);
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}

