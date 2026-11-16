import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/notifications/global_app_notification.dart';
import 'package:task_nest/core/notifications/noti_service.dart';
import 'package:task_nest/core/notifications/notifications_provider.dart';
import 'package:task_nest/core/utils/set_routines_reminders.dart';
import 'package:task_nest/core/utils/utils.dart';

class SettingsBody extends ConsumerStatefulWidget {
  const SettingsBody({super.key});

  @override
  ConsumerState<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends ConsumerState<SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(spacing: 5, children: [_settingsCard(context)]),
      ),
    );
  }

  Card _settingsCard(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            _notificationsTile(),
            _divider(),
            ListTile(
              minTileHeight: 70,
              leading: const Icon(Icons.info),
              title: Text(
                localization(context).about,
                style: textTheme(context).bodyMedium,
              ),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }

  Divider _divider() {
    return const Divider(
      indent: 50,
      endIndent: 20,
      thickness: 1,
      height: 0,
      color: Colors.grey,
    );
  }

  ListTile _notificationsTile() {
    final notificationsEnabled = ref.watch(notificationProvider).setted;
    return ListTile(
      onTap: () => Navigator.pushNamed(context, '/notifications'),
      minTileHeight: 70,
      leading: const Icon(Icons.notifications, size: 25),
      title: Text(
        localization(context).notifications,
        style: textTheme(context).bodyMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            thumbIcon: WidgetStatePropertyAll(
              Icon(
                notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
              ),
            ),
            value: notificationsEnabled,
            onChanged: (value) async {
              if (value) {
                await setGlobalAppNotification(ref, context);
                if (mounted) {
                  await setRoutinesReminders(context, ref);
                }
                ref.watch(notificationProvider).changeValue(value);
              } else {
                NotiService().cancelAllNotifications();
                ref.watch(notificationProvider).changeValue(value);
              }
            },
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
