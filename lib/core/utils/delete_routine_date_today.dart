import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';

Future<void> deleteRoutineDateToday(
    WidgetRef ref, Routine routineToDelete) async {
  final dateNotifier = ref.watch(dateProvider);
  final dates = ref.watch(dateProvider).dates;

  //today for finding
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  //avoiding any casualty
  if (dates == null) return;

  final dateModelIndex = dates.indexWhere(
    (dateModel) => dateModel.date.isAtSameMomentAs(today),
  );

  //stops if can't find it
  if (dateModelIndex == -1) return;

  final DateModel dateModelToday = dates[dateModelIndex];

  //deletes the routine
  dateModelToday.routines.removeWhere(
    (routine) => routine.id == routineToDelete.id,
  );

  dateModelToday.completedRoutineAmount = _getCompletedQuantity(dateModelToday);

  //replaces the dateModel in the provider
  dates.removeAt(dateModelIndex);
  dates.insert(dateModelIndex, dateModelToday);

  //updates in the local database
  await dateNotifier.upsertDate(dateModelToday);
}

int _getCompletedQuantity(DateModel dateModel) {
  int result = 0;
  for (var routine in dateModel.routines) {
    result += routine.finished! ? 1 : 0;
  }
  return result;
}
