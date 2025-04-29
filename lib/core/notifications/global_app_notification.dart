import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';

Future<void> setGlobalAppNotification(WidgetRef ref, BuildContext context) async {
  final timeOfDayNotifier = ref.watch(startAndEndTimeProvider);
  final start = timeOfDayNotifier.start;
  final end = timeOfDayNotifier.end;

  await NotiService().scheduleNotification(
      title: localization(context).morningNotiTitle,
      body: localization(context).morningNotiBody,
      hour: stringToTimeOfDay(start).hour,
      minute: stringToTimeOfDay(start).minute);

  await NotiService().scheduleNotification(
      title: localization(context).nightNotiTitle,
      body: localization(context).nightNotiBody,
      hour: ((stringToTimeOfDay(end).hour - 2) % 24),
      minute: stringToTimeOfDay(end).minute);
}
