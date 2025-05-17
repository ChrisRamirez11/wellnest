import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/providers.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/seleted_time_range_provider.dart';

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
        color: primary.withAlpha(200),
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
              MenuAnchor(
                controller: menuController,
                alignmentOffset: const Offset(0, -200),
                menuChildren: TimeRange.values.map((timeRange) {
                  return MenuItemButton(
                    child: Row(
                      children: [
                        Icon(timeRangeIcons[timeRange], size: 20),
                        const SizedBox(width: 8),
                        Text(timeRangeLabels[timeRange]!),
                      ],
                    ),
                    onPressed: () {
                      ref.read(selectedTimeRangeProvider.notifier).state =
                          timeRange;
                      menuController.close();
                    },
                  );
                }).toList(),
                child: InkWell(
                  onTap: () => menuController.isOpen
                      ? menuController.close()
                      : menuController.open(),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: primary),
                    ),
                    child: Icon(timeRangeIcons[selectedTimeRange], size: 20),
                  ),
                ),
              ),

              // Send button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isTyping && !aiCoachState.loading)
                        ? secondary
                        : secondary.withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: primary),
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
