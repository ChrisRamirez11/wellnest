import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';

Future<void> validateDateModel(
    List<RoutineModel> routines, DateTime date, WidgetRef ref) async {
  final dateNotifier = ref.watch(dateProvider);
  List<RoutineModel> routinesList = [];
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateModel dateModel =
      DateModel(date: date, routines: [], completedRoutineAmount: 0);

  for (final d in dateNotifier.dates!) {
    if (d.date.isAtSameMomentAs(date)) {
      dateNotifier.setDate(d);
      return;
    }
  }

  //routines list sorting
  routines.sort(
    (a, b) => a.createdDate.compareTo(b.createdDate),
  );

  if (routines.isNotEmpty) {
    if ((date.isBefore(today) || date.isAtSameMomentAs(today)) &&
        (routines.first.createdDate.isBefore(date) ||
            routines.first.createdDate.isAtSameMomentAs(date))) {
      for (var routine in routines) {
        if (routine.createdDate.isBefore(date) ||
            routine.createdDate.isAtSameMomentAs(date) &&
                routines.first.createdDate.isBefore(date) ||
            routines.first.createdDate.isAtSameMomentAs(date)) {
          for (int i = 0; i < routine.days.length; i++) {
            if (routine.days[i] && (adjustedWeekday(date) == (i + 1))) {
              routinesList.add(routine);
            }
          }
        }
      }

      dateModel.routines = routinesList
          .map(
            (e) => Routine.fromModel(e),
          )
          .toList();
      await dateNotifier.upsertDate(dateModel);
    } else {
      for (var routine in routines) {
        if (routine.createdDate.isBefore(date) ||
            routine.createdDate.isAtSameMomentAs(date) &&
                routines.first.createdDate.isBefore(date) ||
            routines.first.createdDate.isAtSameMomentAs(date)) {
          for (int i = 0; i < routine.days.length; i++) {
            if (routine.days[i] && (adjustedWeekday(date) == (i + 1))) {
              routinesList.add(routine);
            }
          }
        }
      }
      dateModel.routines = routinesList
          .map(
            (e) => Routine.fromModel(e),
          )
          .toList();
      dateNotifier.setDate(dateModel);
    }
  } else {
    dateNotifier.setDate(dateModel);
  }
}

int adjustedWeekday(DateTime date) {
  int weekday = date.weekday;
  return weekday == 7 ? 1 : weekday + 1;
}
