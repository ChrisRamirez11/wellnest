import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/seleted_time_range_provider.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_text_box.dart';

final Map<TimeRange, Color> timeRangeColors = {
  TimeRange.none: Colors.transparent,
  TimeRange.weekData: Colors.lightBlue.withAlpha(200),
  TimeRange.monthData: Colors.lightBlue.withAlpha(200),
};

class CustomMenuAnchor extends ConsumerWidget {
  const CustomMenuAnchor({
    super.key,
    required this.menuController,
    required this.selectedTimeRange,
  });

  final MenuController menuController;
  final TimeRange selectedTimeRange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<TimeRange, String> timeRangeLabels = {
      TimeRange.none: localization(context).dontSendData,
      TimeRange.weekData: localization(context).weekData,
      TimeRange.monthData: localization(context).monthData,
    };

    return MenuAnchor(
      style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey.shade800)),
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
            ref.read(selectedTimeRangeProvider.notifier).state = timeRange;
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
          height: 38,
          width: 38,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: timeRangeColors[selectedTimeRange],
            border: Border.all(color: Colors.grey.shade500, width: 0.3),
          ),
          child: Icon(
            timeRangeIcons[selectedTimeRange],
            size: 20,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
