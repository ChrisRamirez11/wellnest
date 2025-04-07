import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/notifications/notifications_provider.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/ads/banner_ad.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/google_native_signin.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/profile_provider.dart';
import 'package:wellnest/feature/settings/presentation/widgets/go_deluxe_button.dart';
import 'package:wellnest/feature/settings/presentation/widgets/language_selection_dialog.dart';
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
          spacing: 5,
          children: [
            getSignInBox(context),
            getGoDeluxeButton(),
            getSettigsBox(context),
            BannerAdWidget(
              cardColor: _cardColor,
            )
          ],
        ),
      ),
    );
  }

  Widget getSignInBox(BuildContext context) {
    final user = supabase.auth.currentUser;
    final profile = ref.watch(profileProvider).profile;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: _cardColor,
      child: (user == null && profile == null)
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
                      localization(context).signIn,
                      style: textTheme(context).bodyLarge,
                    ),
                    subtitle: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 20,
                        child: FittedBox(
                            child: Text(
                          localization(context).backupRestoreComment,
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
      child: GoDeluxeButton(),
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
                Icons.translate,
              ),
              title: Text(
                localization(context).languageTitle,
                style: textTheme(context).bodyMedium,
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) => LanguageSelectionDialog(),
              ),
              trailing: Text(
                localization(context).language,
                style: textTheme(context).bodySmall,
              ),
            ),
            getDivider(),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.hub,
              ),
              title: Text(
                localization(context).contributors,
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
                localization(context).feedback,
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
      onTap: () => Navigator.pushNamed(context, '/notifications'),
      minTileHeight: 70,
      leading: Icon(
        Icons.notifications,
        size: 25,
      ),
      title: Text(
        localization(context).notifications,
        style: textTheme(context).bodyMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
              thumbIcon: WidgetStatePropertyAll(Icon(
                ref.watch(notificationProvider).setted
                    ? Icons.notifications_active
                    : Icons.notifications_off,
              )),
              value: ref.watch(notificationProvider).setted,
              onChanged: (value) async {
                if (value) {
                  await setGlobalAppNotification(ref, context);
                  ref.watch(notificationProvider).changeValue(value);
                } else {
                  NotiService().cancelNotifications();
                  ref.watch(notificationProvider).changeValue(value);
                }
              }),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
