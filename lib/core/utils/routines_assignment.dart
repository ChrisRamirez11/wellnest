import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';

Future<void> routineAssignment(
    WidgetRef ref, List<RoutineModel> routines, DateModel dateModel) async {
  List<int> routinesList = [];

  routines.sort(
    (a, b) => a.createdDate.compareTo(b.createdDate),
  );

  if (dateModel.routinesId.isEmpty) {
    for (var routine in routines) {
      if (routine.createdDate.isBefore(dateModel.date) ||
          routine.createdDate.isAtSameMomentAs(dateModel.date) &&
              routines.first.createdDate.isBefore(dateModel.date)) {
        routinesList.add(routine.id!);
      }
    }
  }
  
  dateModel.routinesId = routinesList;
  log('routineAssignment ${dateModel.id}');
  await ref.watch(dateProvider).upsertDate(dateModel);
}
