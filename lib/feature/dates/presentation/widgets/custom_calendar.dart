import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/heatmap_calendar.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/small_routines/presentation/providers/current_selected_date_provider.dart';

class CustomCalendar extends ConsumerWidget {
  final List<RoutineModel> routines;
  final Widget? heatmapChild;
  const CustomCalendar({super.key, required this.routines, this.heatmapChild});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateNotifier = ref.watch(currentSelectedDateProvider);
    final dates = ref.watch(dateProvider).dates;
    final dateNotifier = ref.watch(dateProvider);
    return HeatMapCalendar(
      onClick: (p0) async {
        //changes the current selected date so it gets marked
        selectedDateNotifier.changeDate(p0);
        //validates DateModel and in any case it'll add the date to _dates and also _date
        //gets updated so you can see its routines and will not break
        await validateDateModel(routines, p0, ref);
      },
      onReturnToActualDate: () {
        selectedDateNotifier.changeDate(DateTime.now());
        dateNotifier.setDate(dateNotifier.dates!
                .where(
                  (element) => element.date.isAtSameMomentAs(
                      selectedDateNotifier.currentSelectedDate),
                )
                .firstOrNull ??
            DateModel(
                date: selectedDateNotifier.currentSelectedDate,
                routines: [],
                completedRoutineAmount: 0));
      },
      showReturnToActualDate: true,
      weekTextColor: ghostWhite,
      currentSelectedDateColor: secondary,
      currentSelectedDate: selectedDateNotifier.currentSelectedDate,
      showColorTip: false,
      defaultColor: Colors.transparent,
      textColor: secondary,
      weekFontSize: 20,
      monthFontSize: 25,
      borderRadius: 12,
      colorTipCount: 5,
      colorTipSize: 20,
      fontSize: 20,
      size: 70,
      initDate: DateTime.now(),
      datasets: _getDataset(dates),
      colorsets: {
        01: Colors.lightBlue.withValues(alpha: 0.4),
        03: Colors.lightBlue.withValues(alpha: 0.6),
        05: Colors.lightBlue.withValues(alpha: 0.8),
        07: Colors.lightBlue.withValues(alpha: 1.0),
      },
      child: heatmapChild,
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
