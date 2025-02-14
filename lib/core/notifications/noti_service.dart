import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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
    int? id,
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

    await notificationsPlugin.zonedSchedule(
        id ?? UniqueKey().hashCode, title, body, scheduledDate, notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);

    debugPrint('Scheduled Date: $scheduledDate');
  }

  Future<void> showTestNotification() async {
    await notificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test',
      notificationDetails(),
    );
  }

  Future<void> cancelNotification() async {
    await notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> checkScheduledNotis() async {
    final list = await notificationsPlugin.pendingNotificationRequests();
    
    log(list.length.toString());
  for(var e in list){
    log(e.body ?? 'xd');
  }
    return list;
  }
}
