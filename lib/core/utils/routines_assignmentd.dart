import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';

Future<void> routineAssignment(WidgetRef ref, List<RoutineModel> routines, DateModel dateModel) async {
  //TODO
  //it'll sort first the routines by its createdDate, from the old one to the newest one
  //it'll store it in a date variable and if the dateModel.date is before that oldest
  //routine, the dateModel won't be upserted
  if (dateModel.routinesId.isEmpty) {
    for (var routine in routines) {
      if (routine.createdDate.isBefore(dateModel.date) || routine.createdDate.isAtSameMomentAs(dateModel.date)) {
        dateModel.routinesId.add(routine.id!);
        await ref.watch(dateProvider).upsertDate(dateModel);
      }
    }
  }
}
