import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/utils/set_routines_reminders.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/l10n/app_localizations.dart';

class LanguageSelectionDialog extends ConsumerWidget {
  const LanguageSelectionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleDialog(
        title: Text(
          localization(context).selectLanguage,
          style: textTheme(context).bodyLarge,
        ),
        children: [
          SizedBox(
            width: size(context).width * .9,
            height: size(context).height * .6,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppLocalizations.supportedLocales.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  getLanguageFromCode(AppLocalizations.supportedLocales[index]),
                  style: textTheme(context).labelMedium,
                ),
                //if provider locale null, it'll compare with device's
                trailing: (ref.watch(localeProvider).locale?.languageCode ??
                            View.of(context)
                                .platformDispatcher
                                .locale
                                .languageCode) ==
                        AppLocalizations.supportedLocales[index].languageCode
                    ? Icon(Icons.done)
                    : SizedBox.shrink(),
                onTap: () async {
                  //Cancels all notifications
                  await NotiService().cancelAllNotifications();

                  //Changes the language
                  ref.watch(localeProvider).changeLocale(
                      AppLocalizations.supportedLocales[index].languageCode);

                  //Sets again the notifications, so it's translated
                  if (context.mounted) {
                    await setGlobalAppNotification(ref, context);
                  }if (context.mounted) {
                    await setRoutinesReminders(context, ref);
                  }
                  
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ),
          )
        ]);
  }

  String getLanguageFromCode(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return "Español";
      case 'fr':
        return "Français";
      case 'ja':
        return "日本語";
      default:
        return locale.languageCode;
    }
  }
}
