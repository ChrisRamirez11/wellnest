import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/providers.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/seleted_time_range_provider.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/custom_menu_anchor.dart';

enum TimeRange {
  none,
  weekData,
  monthData,
}

final Map<TimeRange, IconData> timeRangeIcons = {
  TimeRange.none: Icons.block,
  TimeRange.weekData: Icons.calendar_view_week,
  TimeRange.monthData: Icons.calendar_month,
};

final Map<TimeRange, String> timeRangeLabels = {
  TimeRange.none: "Don't Send Data",
  TimeRange.weekData: 'Week Data',
  TimeRange.monthData: 'Month Data',
};

typedef OnMessageSubmitted = void Function(String message, TimeRange period);

class ChatTextBox extends ConsumerStatefulWidget {
  final OnMessageSubmitted onSubmitted;
  final TimeRange initialPeriod;

  const ChatTextBox({
    super.key,
    required this.onSubmitted,
    this.initialPeriod = TimeRange.none,
  });

  @override
  ConsumerState<ChatTextBox> createState() => _ChatTextBoxState();
}

class _ChatTextBoxState extends ConsumerState<ChatTextBox> {
  late TextEditingController messageController;
  bool isTyping = false;
  final menuController = MenuController();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTimeRange = ref.watch(selectedTimeRangeProvider);
    final aiCoachState = ref.watch(aiCoachNotifierProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme(context).onInverseSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: messageController,
            onChanged: (text) => setState(
              () => isTyping = text.trim().isNotEmpty,
            ),
            style: textTheme(context).labelMedium,
            decoration: const InputDecoration(
              hintText: 'Message Axio...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            maxLines: 3,
            minLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TimeRange selector
              CustomMenuAnchor(
                  menuController: menuController,
                  selectedTimeRange: selectedTimeRange),

              // Send button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isTyping && !aiCoachState.loading)
                        ? ghostWhite
                        : ghostWhite.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: obsidian),
                ),
                onPressed: (isTyping && !aiCoachState.loading)
                    ? () async {
                        final text = messageController.text.trim();
                        messageController.clear();
                        setState(() => isTyping = false);

                        ref.read(selectedTimeRangeProvider.notifier).state =
                            TimeRange.none;

                        widget.onSubmitted(text, selectedTimeRange);
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
