import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/global_providers/global_noti_ids.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/screens/create_routine.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeNotifier = ref.watch(startAndEndTimeProvider);
    final globalNotiNotifier = ref.watch(globalNotiIdsProvider);

    final reminderDatesList = _getRemindedDateList(ref);

    final start = timeNotifier.start;
    final end = timeNotifier.end;

    return Scaffold(
      appBar: CustomAppBar(
        titleString: localization(context).notifications,
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(children: [
        //Morning Notification
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
                      labelLarge: TextStyle(fontSize: 15),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (time != null) {
              timeNotifier.setStartOfDay(time);

              //resets the day notifications
              if (context.mounted) {
                await NotiService().scheduleNotification(
                    id: globalNotiNotifier.morningId,
                    title: localization(context).morningNotiTitle,
                    body: localization(context).morningNotiBody,
                    hour: stringToTimeOfDay(start).hour,
                    minute: stringToTimeOfDay(start).minute);
              }
            }
          },
        ),

        //Night Notification
        _NotificationCard(
          icon: Icons.nights_stay_outlined,
          title: localization(context).nightNoti,
          time: TimeOfDay(
              hour: ((stringToTimeOfDay(timeNotifier.end).hour - 2) % 24),
              minute: stringToTimeOfDay(timeNotifier.end).minute),
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
                      labelLarge: TextStyle(fontSize: 15),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (time != null) {
              timeNotifier.setEndOfDay(time);

              //resets the night notification
              if (context.mounted) {
                await NotiService().scheduleNotification(
                    id: globalNotiNotifier.nightId,
                    title: localization(context).nightNotiTitle,
                    body: localization(context).nightNotiBody,
                    hour: ((stringToTimeOfDay(end).hour - 2) % 24),
                    minute: stringToTimeOfDay(end).minute);
              }
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
        _getRemindRoutinesTiles(reminderDatesList)
      ]),
    );
  }

  Widget _getRemindRoutinesTiles(List<RoutineModel> reminderDates) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: primary.withAlpha(150),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: reminderDates.length,
              itemBuilder: (context, i) => Column(
                children: [
                  SizedBox(
                    //for the list tile height
                    height: 60,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          reminderDates[i].name,
                          style: textTheme(context).bodyMedium,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRoutineScreen(
                              routineModel: reminderDates[i],
                            ),
                          )),
                    ),
                  ),
                  Divider(
                    height: 5,
                    thickness: 0.5,
                    color: secondary,
                    endIndent: 40,
                    indent: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<RoutineModel> _getRemindedDateList(WidgetRef ref) {
    final routineNotifier = ref.watch(routineProvider);
    final routinesList = routineNotifier.routines!;
    List<RoutineModel> reminderRoutines = [];

    for (final routine in routinesList) {
      if (routine.alarmActive != null ? routine.alarmActive! : false) {
        reminderRoutines.add(routine);
      }
    }

    return reminderRoutines;
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
                    style: textTheme(context).bodyMedium,
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
