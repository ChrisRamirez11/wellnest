import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/core/utils/utils.dart';

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
                trailing: ref.watch(localeProvider).locale ==
                        AppLocalizations.supportedLocales[index].languageCode
                    ? Icon(Icons.done)
                    : SizedBox.shrink(),
                onTap: () {
                  ref.watch(localeProvider).changeLocale(
                      AppLocalizations.supportedLocales[index].languageCode);
                  Navigator.pop(context);
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
