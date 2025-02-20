import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/notifications/notifications_provider.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/google_native_signin.dart';
import 'package:wellnest/feature/settings/presentation/widgets/user_signed_button.dart';
import 'package:wellnest/main.dart';

final _cardColor = primary.withAlpha(200);

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
        child: Column(
          spacing: 10,
          children: [
            getSignInBox(context),
            // getGoDeluxeButton(),
            getSettigsBox(context),
          ],
        ),
      ),
    );
  }

  Widget getSignInBox(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: _cardColor,
      child: user == null
          ? InkWell(
              onTap: () async {
                await googleNativeSignIn();
                if (mounted) {
                  setState(() {});
                }
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    minTileHeight: 70,
                    title: Text(
                      'Google Sign In',
                      style: textTheme(context).bodyLarge,
                    ),
                    subtitle: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 20,
                        child: FittedBox(
                            child: Text(
                          'Sign in to sync and backup data',
                          style: textTheme(context)
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        )),
                      ),
                    ),
                    trailing: Icon(Icons.backup),
                  ),
                ),
              ),
            )
          : const UserSignedButton(),
    );
  }

  Widget getGoDeluxeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            icon: const Icon(
              Icons.workspace_premium,
              size: 30,
              color: Colors.white,
            ),
            onClick: () {},
            text: 'GO DELUXE',
            color: secondary.withAlpha(150),
          )),
    );
  }

  Card getSettigsBox(BuildContext context) {
    return Card(
      color: _cardColor,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            getNotificationsTile(),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.hub,
              ),
              title: Text(
                'Contributors',
                style: textTheme(context).bodyMedium,
              ),
              onTap: () => Navigator.pushNamed(context, '/community'),
            ),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.feedback,
              ),
              title: Text(
                'Feedback',
                style: textTheme(context).bodyMedium,
              ),
              onTap: () => Navigator.pushNamed(context, '/feedback'),
            ),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.info,
              ),
              title: Text(
                'About Us',
                style: textTheme(context).bodyMedium,
              ),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }

  Divider getDivider() {
    return Divider(
      indent: 50,
      endIndent: 20,
      thickness: 1,
      height: 0,
      color: Colors.grey,
    );
  }

  ListTile getNotificationsTile() {
    return ListTile(
      minTileHeight: 70,
      leading: Icon(
        Icons.notifications,
        size: 25,
      ),
      title: Text(
        'Notifications',
        style: textTheme(context).bodyMedium,
      ),
      trailing: Switch(
          thumbIcon: WidgetStatePropertyAll(Icon(
            ref.watch(notificationProvider).setted
                ? Icons.notifications
                : Icons.notifications_off,
          )),
          value: ref.watch(notificationProvider).setted,
          onChanged: (value) async {
            if (value) {
              await NotiService().scheduleNotification(
                  title: 'Good Morning',
                  body:
                      'Review your daily routines and finish them as you go. Dont forget mark them as done',
                  hour: 6,
                  minute: 0);

              await NotiService().scheduleNotification(
                  title: 'Hey There',
                  body:
                      'End your day by reviewing unfinished tasks and wrapping them up.',
                  hour: 17,
                  minute: 0);
              ref.watch(notificationProvider).changeValue(value);
            } else {
              NotiService().cancelNotifications();
              ref.watch(notificationProvider).changeValue(value);
            }
          }),
    );
  }
}
