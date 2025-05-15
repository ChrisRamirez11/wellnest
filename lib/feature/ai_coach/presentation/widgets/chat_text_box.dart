import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';

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

class ChatTextBox extends StatelessWidget {
  final OnMessageSubmitted onSubmitted;
  final TimeRange initialPeriod;

  const ChatTextBox({
    super.key,
    required this.onSubmitted,
    this.initialPeriod = TimeRange.none,
  });

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    var isTyping = false;
    var selectedTimeRange = initialPeriod;
    final menuController = MenuController();

    return StatefulBuilder(
      builder: (context, setState) {
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
                          setState(() => selectedTimeRange = timeRange);
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
                        child:
                            Icon(timeRangeIcons[selectedTimeRange], size: 20),
                      ),
                    ),
                  ),

                  // Send button
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isTyping ? secondary : secondary.withAlpha(150),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: primary),
                    ),
                    onPressed: isTyping
                        ? () {
                            final text = messageController.text.trim();
                            messageController.clear();
                            setState(() => isTyping = false);
                            onSubmitted(text, selectedTimeRange);
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
