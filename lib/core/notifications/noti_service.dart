import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //initilize
  Future<void> initNotifications() async {
    if (_isInitialized) return;

    //init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidSettings = AndroidInitializationSettings('app_icon');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await notificationsPlugin.initialize(initSettings);

    _isInitialized = true;
  }

  //notifications setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'Daily Notifications',
            channelDescription: 'Daily Notifications Channel',
            importance: Importance.max,
            priority: Priority.max),
        iOS: DarwinNotificationDetails());
  }

  //Scheduled Notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final alarmsPermission = await Permission.scheduleExactAlarm.isGranted;

    await notificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: alarmsPermission
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);

    debugPrint('Scheduled Date: $scheduledDate');
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
    debugPrint('Notifications Cancelled');
  }

  Future<void> cancelNotificationById(int id) async {
    await notificationsPlugin.cancel(id);
    debugPrint('Notification $id Cancelled');
  }

  Future<List<PendingNotificationRequest>> checkScheduledNotis() async {
    final list = await notificationsPlugin.pendingNotificationRequests();

    for (var e in list) {
      debugPrint('checkScheduledNotis for: ${e.body ?? 'xd'}');
    }
    return list;
  }
}
