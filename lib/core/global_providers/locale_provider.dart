import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';

final localeProvider =
    ChangeNotifierProvider<LocaleProvider>((ref) => LocaleProvider());

class LocaleProvider extends ChangeNotifier {
  final prefs = UserPreferences();
  late Locale? _locale;

  LocaleProvider() {
    _locale = prefs.locale != null ? Locale(prefs.locale!) : null;
  }

  Locale? get locale => _locale;

  void changeLocale(String localeLanguageCode) {
    // This method changes the locale and updates the UserPreferences
    _locale = Locale(localeLanguageCode);
    prefs.locale = localeLanguageCode; // Update the stored locale
    notifyListeners();
  }
}
