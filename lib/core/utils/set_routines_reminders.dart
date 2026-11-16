import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/notifications/noti_service.dart';
import 'package:task_nest/core/utils/string_to_time_of_day.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/feature/routines/presentation/providers/routine_provider.dart';

Future<void> setRoutinesReminders(BuildContext context, WidgetRef ref) async {
  final routinesList = ref.watch(routineProvider).routines!;

  for (final routine in routinesList) {
    if (routine.alarmActive != null ? routine.alarmActive! : false) {
      await NotiService().scheduleNotification(
          id: routine.id!,
          title: routine.name,
          body: localization(context).routineReminderBody,
          hour: stringToTimeOfDay(routine.alarmTime!).hour,
          minute: stringToTimeOfDay(routine.alarmTime!).minute);
    }
  }
}
