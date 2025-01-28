import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/flutter_heatmap_calendar/src/heatmap_calendar.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: HeatMapCalendar(
        showColorTip: false,
        textColor: obsidian,
        defaultColor: secondary,
        weekFontSize: 20,
        monthFontSize: 25,
        borderRadius: 10,
        colorTipCount: 5,
        colorTipSize: 20,
        fontSize: 20,
        size: 70,
        initDate: DateTime(2025, 12, 31),
        datasets: {
          DateTime(2025, 12, 31): 0,
          DateTime(2025, 12, 30): 20,
          DateTime(2025, 12, 29): 30,
          DateTime(2025, 12, 28): 40,
          DateTime(2025, 12, 26): 50,
          DateTime(2025, 12, 22): 60,
          DateTime(2025, 12, 12): 999,
          DateTime(2025, 12, 1): 0,
          DateTime(2025, 11, 23): 12,
          DateTime(2025, 12, 16): 34,
          DateTime(2025, 12, 15): 45,
          DateTime(2025, 12, 12): 89,
          DateTime(2020, 1, 16): 34,
          DateTime(2020, 1, 15): 45,
          DateTime(2020, 1, 12): 89,
        },
        colorsets: {
          10: primary.withValues(alpha: 0.2),
          20: primary.withValues(alpha: 0.3),
          30: primary.withValues(alpha: 0.4),
          40: primary.withValues(alpha: 0.5),
          50: primary,
        },
      ),
    );
  }
}