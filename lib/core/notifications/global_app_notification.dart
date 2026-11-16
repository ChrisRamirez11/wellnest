import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/global_providers/global_noti_ids.dart';
import 'package:task_nest/core/notifications/noti_service.dart';
import 'package:task_nest/core/utils/string_to_time_of_day.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';

Future<void> setGlobalAppNotification(
    WidgetRef ref, BuildContext context) async {
  final timeOfDayNotifier = ref.watch(startAndEndTimeProvider);
  final globalNotiNotifier = ref.watch(globalNotiIdsProvider);

  final start = timeOfDayNotifier.start;
  final end = timeOfDayNotifier.end;

  final morningId = globalNotiNotifier.morningId;
  final nightId = globalNotiNotifier.nightId;

  await NotiService().scheduleNotification(
      id: morningId,
      title: localization(context).morningNotiTitle,
      body: localization(context).morningNotiBody,
      hour: stringToTimeOfDay(start).hour,
      minute: stringToTimeOfDay(start).minute);

  if (context.mounted) {
    await NotiService().scheduleNotification(
        id: nightId,
        title: localization(context).nightNotiTitle,
        body: localization(context).nightNotiBody,
        hour: ((stringToTimeOfDay(end).hour - 2) % 24),
        minute: stringToTimeOfDay(end).minute);
  }
}
