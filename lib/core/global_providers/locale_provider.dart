import 'package:wellnest/main_imports.dart';

final localeProvider =
    ChangeNotifierProvider<LocaleProvider>((ref) => LocaleProvider());

class LocaleProvider extends ChangeNotifier {
  final prefs = UserPreferences();
  late String _locale;

  LocaleProvider() {
    _locale = prefs.locale;
  }

  String get locale => _locale;

  void changeLocale(String newLocale) {
    // This method changes the locale and updates the UserPreferences
    _locale = newLocale;
    prefs.locale = newLocale; // Update the stored locale
    notifyListeners();
  }
}
