import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';

void setGlobalAppNotification(WidgetRef ref) async {
  final timeOfDayNotifier = ref.watch(startAndEndTimeProvider);
  final start = timeOfDayNotifier.start;
  final end = timeOfDayNotifier.end;

  await NotiService().scheduleNotification(
      title: 'Good Morning',
      body:
          'Review your daily routines and finish them as you go. Dont forget mark them as done',
      hour: stringToTimeOfDay(start).hour,
      minute: stringToTimeOfDay(start).minute);

  await NotiService().scheduleNotification(
      title: 'Hey There',
      body: 'End your day by reviewing unfinished tasks and wrapping them up.',
      hour: (stringToTimeOfDay(end).hour - 2) % 24,
      minute: stringToTimeOfDay(end).minute);
}
