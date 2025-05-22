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

    return Scaffold(
      appBar: CustomAppBar(
        titleString: localization(context).notifications,
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(children: [
        // Morning Notification
        FutureBuilder<bool>(
          future: NotiService().isNotiActive(globalNotiNotifier.morningId),
          builder: (context, snapshot) {
            final isActive = snapshot.data ?? false;

            return _NotificationCard(
              icon: Icons.wb_sunny,
              title: localization(context).morningNoti,
              time: stringToTimeOfDay(timeNotifier.start),
              notiId: globalNotiNotifier.morningId,
              switchValue: isActive,
              onPressed: () async {
                final time = await showTimePicker(
                  initialEntryMode: TimePickerEntryMode.input,
                  context: context,
                  initialTime: stringToTimeOfDay(timeNotifier.start),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: const TextTheme(
                            labelLarge: TextStyle(fontSize: 15)),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  timeNotifier.setStartOfDay(time);
                  if (context.mounted) {
                    await NotiService().scheduleNotification(
                      id: globalNotiNotifier.morningId,
                      title: localization(context).morningNotiTitle,
                      body: localization(context).morningNotiBody,
                      hour: time.hour,
                      minute: time.minute,
                    );
                  }
                }
              },
            );
          },
        ),

        // Night Notification
        FutureBuilder<bool>(
          future: NotiService().isNotiActive(globalNotiNotifier.nightId),
          builder: (context, snapshot) {
            final isActive = snapshot.data ?? false;

            return _NotificationCard(
              icon: Icons.nights_stay_outlined,
              title: localization(context).nightNoti,
              time: stringToTimeOfDay(timeNotifier.end),
              notiId: globalNotiNotifier.nightId,
              switchValue: isActive,
              onPressed: () async {
                final time = await showTimePicker(
                  initialEntryMode: TimePickerEntryMode.input,
                  context: context,
                  initialTime: stringToTimeOfDay(timeNotifier.end),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: const TextTheme(
                            labelLarge: TextStyle(fontSize: 15)),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  timeNotifier.setEndOfDay(time);
                  if (context.mounted) {
                    await NotiService().scheduleNotification(
                      id: globalNotiNotifier.nightId,
                      title: localization(context).nightNotiTitle,
                      body: localization(context).nightNotiBody,
                      hour: ((time.hour - 2) % 24),
                      minute: time.minute,
                    );
                  }
                }
              },
            );
          },
        ),

        const SizedBox(height: 10),
        _getRemindRoutinesTiles(reminderDatesList),
      ]),
    );
  }

  Widget _getRemindRoutinesTiles(List<RoutineModel> reminderDates) {
    return reminderDates.isNotEmpty
        ? Padding(
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
          )
        : SizedBox.shrink();
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

class _NotificationCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final TimeOfDay time;
  final VoidCallback? onPressed;
  final int notiId;
  final bool switchValue;

  const _NotificationCard(
      {required this.icon,
      required this.title,
      required this.time,
      required this.onPressed,
      required this.notiId,
      required this.switchValue});

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _switchFlag = false;

  @override
  void initState() {
    super.initState();
    _switchFlag = widget.switchValue;
  }

  @override
  void didUpdateWidget(covariant _NotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.switchValue != widget.switchValue) {
      setState(() {
        _switchFlag = widget.switchValue;
      });
    }
  }

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
                Icon(widget.icon, size: 32.0),
                Expanded(
                  child: Text(
                    widget.title,
                    style: textTheme(context).bodyMedium,
                  ),
                ),
                Switch(
                  value: _switchFlag,
                  onChanged: (value) async {
                    setState(() {
                      _switchFlag = value;
                    });
                    if (value) {
                      await NotiService().scheduleNotification(
                        id: widget.notiId,
                        title: localization(context).nightNotiTitle,
                        body: localization(context).nightNotiBody,
                        hour: widget.time.hour,
                        minute: widget.time.minute,
                      );
                    } else {
                      await NotiService().cancelNotificationById(widget.notiId);
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48), // Full width button
                  backgroundColor: Colors.transparent),
              child: Text(
                  style: textTheme(context).bodyMedium,
                  '${widget.time.hour.toString().padLeft(2, '0')}:${widget.time.minute.toString().padLeft(2, '0')}'),
            ),
          ],
        ),
      ),
    );
  }
}
