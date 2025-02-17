import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/notifications/notifications_provider.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/google_native_signin.dart';
import 'package:wellnest/feature/settings/presentation/widgets/user_signed_button.dart';
import 'package:wellnest/main.dart';

final _cardColor = primary.withAlpha(150);

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
            getGoDeluxButton(),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    minTileHeight: 70,
                    title: Text('Google Sign In'),
                    subtitle: Text('Sign in to sync and backup data'),
                    trailing: Icon(Icons.backup),
                  ),
                ),
              ),
            )
          : const UserSignedButton(),
    );
  }

  Widget getGoDeluxButton() {
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
    final prefs = UserPreferences();
    return Card(
      color: _cardColor,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            getNotificationsTile(prefs),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.hub,
              ),
              title: Text('Contributors'),
              onTap: () => Navigator.pushNamed(context, '/community'),
            ),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.feedback,
              ),
              title: Text('Feedback'),
              onTap: () => Navigator.pushNamed(context, '/feedback'),
            ),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.info,
              ),
              title: Text('About Us'),
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

  ListTile getNotificationsTile(UserPreferences prefs) {
    return ListTile(
      minTileHeight: 70,
      leading: Icon(
        Icons.notifications,
        size: 25,
      ),
      title: Text('Notification'),
      trailing: Switch(
          value: prefs.notiOption,
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
