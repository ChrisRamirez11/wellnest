import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeNotifier = ref.watch(startAndEndTimeProvider);

    return Scaffold(
      appBar: CustomAppBar(titleString: localization(context).notifications),
      body: Column(children: [
        _NotificationCard(
          icon: Icons.wb_sunny,
          title: localization(context).morningNoti,
          time: stringToTimeOfDay(timeNotifier.start),
          onPressed: () async {
            //shows the time picker
            final time = await showTimePicker(
              initialEntryMode: TimePickerEntryMode.input,
              context: context,
              initialTime: stringToTimeOfDay(timeNotifier.start),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: TextTheme(
                      labelLarge:
                          TextStyle(fontSize: 15), // Ajusta el tamaño de fuente
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (time != null) {
              timeNotifier.setStartOfDay(time);

              //cancells the notifications
              await NotiService().cancelNotifications();

              //resets the notifications
              if (context.mounted) {
                await setGlobalAppNotification(ref, context);
              }
            }
          },
        ),
        _NotificationCard(
          icon: Icons.nights_stay_outlined,
          title: localization(context).nightNoti,
          time: stringToTimeOfDay(timeNotifier.end),
          onPressed: () async {
            //TODO every timepicker will use a common time picker, no repeating the same thing so many times
            //shows the time picker
            final time = await showTimePicker(
              initialEntryMode: TimePickerEntryMode.input,
              context: context,
              initialTime: stringToTimeOfDay(timeNotifier.end),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: TextTheme(
                      labelLarge:
                          TextStyle(fontSize: 15), // Ajusta el tamaño de fuente
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (time != null) {
              timeNotifier.setEndOfDay(time);

              //cancells the notifications
              await NotiService().cancelNotifications();

              //resets the notifications
              if (context.mounted) {
                await setGlobalAppNotification(ref, context);
              }
            }
          },
        ),
      ]),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final TimeOfDay time;
  final VoidCallback? onPressed;

  const _NotificationCard(
      {required this.icon,
      required this.title,
      required this.time,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primary.withAlpha(150),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 20,
              children: [
                const SizedBox.shrink(),
                Icon(icon, size: 32.0),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48), // Full width button
                  backgroundColor: Colors.transparent),
              child: Text(
                  style: textTheme(context).bodyMedium,
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'),
            ),
          ],
        ),
      ),
    );
  }
}
