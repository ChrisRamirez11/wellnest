import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';

Future<void> validateDateModel(
    List<RoutineModel> routines, DateTime date, WidgetRef ref) async {
  final dateNotifier = ref.watch(dateProvider);
  List<int> routinesList = [];
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateModel dateModel =
      DateModel(date: date, routinesId: [], completedRoutineAmount: 0);

  for (final d in dateNotifier.dates!) {
    if (d.date.isAtSameMomentAs(date)) {
      dateNotifier.setDate(d);
      return;
    }
  }

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
          routinesList.add(routine.id!);
        }
      }

      dateModel.routinesId = routinesList;
      await dateNotifier.upsertDate(dateModel);
    } else {
      dateNotifier.setDate(dateModel);
    }
  } else {
    dateNotifier.setDate(dateModel);
  }
}
