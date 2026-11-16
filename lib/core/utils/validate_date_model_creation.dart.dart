import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';

Future<void> validateDateModel(
    List<RoutineModel> routines, DateTime date, WidgetRef ref) async {
  final dateNotifier = ref.watch(dateProvider);

  // 1) Search if there is already a DateModel for that date
  DateModel? existingDate;
  if (dateNotifier.dates != null) {
    for (final d in dateNotifier.dates!) {
      if (d.date.isAtSameMomentAs(date)) {
        existingDate = d;
        break;
      }
    }
  }
  if (existingDate != null) {
    dateNotifier.setDate(existingDate);
    return;
  }

  // 2) Normalize "today" to midnight
  final now = DateTime.now();
  final normalizedToday = DateTime(now.year, now.month, now.day);

  // 3) Sort routines by creation date
  routines.sort((a, b) => a.createdDate.compareTo(b.createdDate));

  // 4) Always filter by: created ≤ selected date && active on that day of the week
  //    AND if endAt is set, it must be on or after the selected date
  final filteredRoutines = routines.where((routine) {
    final createdOk = routine.createdDate.isBefore(date) ||
        routine.createdDate.isAtSameMomentAs(date);
    final runsToday = routine.days[adjustedWeekday(date) - 1];
    final endAtOk = routine.endAt == null ||
        routine.endAt!.isAfter(date) ||
        routine.endAt!.isAtSameMomentAs(date); // New condition for endAt

    return createdOk && runsToday && endAtOk;
  }).toList();

  // 5) Build the model
  final dateModel = DateModel(
    date: date,
    routines: filteredRoutines.map(Routine.fromModel).toList(),
    completedRoutineAmount: 0,
  );

  // 6) If the date is today or in the past, perform upsert in the database; if it's in the future, do not
  final isPastOrToday =
      date.isBefore(normalizedToday) || date.isAtSameMomentAs(normalizedToday);

  if (filteredRoutines.isNotEmpty && isPastOrToday) {
    await dateNotifier.upsertDate(dateModel);
  }

  // 7) Always notify the provider to display the filtered routines
  dateNotifier.setDate(dateModel);
}

int adjustedWeekday(DateTime date) {
  // Convert Sunday(7) → 1, Monday(1) → 2, ..., Saturday(6) → 7
  final w = date.weekday;
  return w == DateTime.sunday ? 1 : w + 1;
}
