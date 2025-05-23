import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/ai_coach/business/entity/ai_coach_prompt.dart';
import 'package:wellnest/feature/ai_coach/business/entity/chat_message_entity.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/ai_coach_state.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/last_prompt_provider.dart';
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

  bool get _isNearBottom {
    const threshold = 300;
    if (!_scrollController.hasClients) return false;

    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    return max - current < threshold;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isNearBottom) {
        _scrollToBottom();
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: obsidian,
          centerTitle: true,
          leading: IconButton(
            enableFeedback: false,
            icon: const Icon(
              Icons.close_rounded,
              color: ghostWhite,
              size: 30,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
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
              icon: const Icon(
                Icons.info_outline,
                color: ghostWhite,
              ),
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
              _AxioErrorContainer(
                state: state,
                scrollToBottom: _scrollToBottom,
              ),
            ChatTextBox(
              onSubmitted: (message, period) async {
                await ref
                    .read(periodDataNotifierProvider.notifier)
                    .generateSummary(selectedTimeRange);

                final prompt = AiCoachPrompt(
                  userId: supabase.auth.currentUser!.id,
                  userMessage: message,
                  language: language?.languageCode ??
                      PlatformDispatcher.instance.locale.languageCode,
                  summary: ref.watch(periodDataNotifierProvider).summary,
                  period: period == TimeRange.none
                      ? null
                      : (period == TimeRange.weekData ? 'week' : 'month'),
                  previousResponseId: state.data?.previousResponseId,
                );

                ref.watch(lastPromptProvider.notifier).state = prompt;
                await notifier.fetchCoachFeedback(prompt);

                _scrollToBottom();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AxioErrorContainer extends ConsumerWidget {
  const _AxioErrorContainer(
      {required this.state, required this.scrollToBottom});

  final AiCoachState state;
  final void Function() scrollToBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: errorColor.withAlpha(30),
          border: Border.all(
              color: errorColor,
              width: 0.6,
              strokeAlign: BorderSide.strokeAlignCenter),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: errorColor,
          ),
          Expanded(
            child: Text(state.error!,
                style: textTheme(context)
                    .labelMedium!
                    .copyWith(color: errorColor)),
          ),
          IconButton(
              onPressed: () async {
                final aiCoachNotifier =
                    ref.read(aiCoachNotifierProvider.notifier);
                final aiCoachState = ref.read(aiCoachNotifierProvider);

                aiCoachState.history.removeLast();

                await aiCoachNotifier
                    .fetchCoachFeedback(ref.read(lastPromptProvider));

                scrollToBottom();
              },
              icon: Icon(
                Icons.restore,
                color: errorColor,
              ))
        ],
      ),
    );
  }
}
