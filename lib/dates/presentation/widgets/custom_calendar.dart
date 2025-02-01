import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/flutter_heatmap_calendar/src/heatmap_calendar.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';
import 'package:wellnest/small_routines/presentation/providers/current_selected_date_provider.dart';

class CustomCalendar extends ConsumerWidget {
  final List<RoutineModel> routines;
  const CustomCalendar({super.key, required this.routines});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSelectedDate = ref.watch(currentSelectedDateProvider);
    final dates = ref.watch(dateProvider).dates;
    final currentSelectedDateColor = coffe;
    return FittedBox(
      fit: BoxFit.fill,
      child: HeatMapCalendar(
        onClick: (p0) async {
          currentSelectedDate.changeDate(p0);
          await validateDateModel(routines, p0, ref);
        },
        currentSelectedDateColor: currentSelectedDateColor,
        currentSelectedDate: currentSelectedDate.currentSelectedDate,
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
        datasets: _getDataset(dates),
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

  Map<DateTime, int> _getDataset(List<DateModel>? dates) {
    final Map<DateTime, int> dataset = {};
    if (dates != null) {
      for (final date in dates) {
        dataset[date.date] = date.completedRoutineAmount;
      }
    }
    return dataset;
  }
}
