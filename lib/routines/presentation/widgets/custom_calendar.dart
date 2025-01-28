import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/flutter_heatmap_calendar/src/heatmap_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    super.key,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  var currentSelectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final currentSelectedDateColor = coffe;
    return FittedBox(
      fit: BoxFit.fill,
      child: HeatMapCalendar(
        onClick: (p0) => setState(() {
          currentSelectedDate = p0;
        }),
        currentSelectedDateColor: currentSelectedDateColor,
        currentSelectedDate: currentSelectedDate,
        showColorTip: false,
        defaultColor: secondary,
        textColor: obsidian,
        weekFontSize: 20,
        monthFontSize: 25,
        borderRadius: 15,
        colorTipCount: 5,
        colorTipSize: 20,
        fontSize: 20,
        size: 70,
        initDate: DateTime.now(),
        datasets: {
          DateTime(2025, 01, 28): 40,
          DateTime(2025, 01, 26): 50,
          DateTime(2025, 01, 22): 60,
          DateTime(2025, 01, 23): 10,
          DateTime(2025, 01, 16): 34,
          DateTime(2025, 01, 15): 45,
          DateTime(2025, 01, 01): 89,
          DateTime(2020, 01, 16): 34,
          DateTime(2020, 01, 15): 45,
          DateTime(2020, 01, 01): 89,
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
