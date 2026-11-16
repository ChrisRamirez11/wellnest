import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/widgets/custom_error_widget.dart';
import 'package:task_nest/feature/dates/presentation/providers/date_provider.dart';
import 'package:task_nest/feature/calendar/presentation/widgets/custom_calendar.dart';
import 'package:task_nest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:task_nest/feature/calendar/presentation/widgets/small_routines_view.dart';

class SmallRoutinesScreen extends ConsumerWidget {
  const SmallRoutinesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateNotifier = ref.watch(dateProvider);
    final dates = ref.watch(dateProvider).dates;
    final failure = ref.watch(dateProvider).failure;
    final routines = ref.watch(routineProvider).routines;
    late Widget widget;
    if (dates != null && routines != null) {
      widget = CustomCalendar(
        routines: routines,
        heatmapChild: dateNotifier.date != null
            ? SmallRoutinesView(dateModel: dateNotifier.date!)
            : const SizedBox(),
      );
    } else if (failure != null) {
      widget = CustomErrorWidget(errorMessage: failure.errorMessage);
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }
}
