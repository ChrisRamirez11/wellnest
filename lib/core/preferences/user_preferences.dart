import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();
  factory UserPreferences() {
    return _instancia;
  }
  
  UserPreferences._internal();
  late SharedPreferencesWithCache _prefs;

  initPrefs() async {
    _prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions());
  }

  set darkMode(bool value) {
    _prefs.setBool('DarkMode', value);
  }

  bool get darkMode {
    return _prefs.getBool('DarkMode') ?? true;
  }

  set cacheUser(String user) {
    _prefs.setString('CachedUser', user);
  }

  String get cacheUser {
    return _prefs.getString('CachedUser') ?? '';
  }

  set backedupData(bool value) {
    _prefs.setBool('BackedupData', value);
  }

  bool get backedupData {
    return _prefs.getBool('BackedupData') ?? false;
  }

  set firstTimeNotiSetted(bool value) {
    _prefs.setBool('firstTimeNotiSetted', value);
  }

  bool get firstTimeNotiSetted {
    return _prefs.getBool('firstTimeNotiSetted') ?? false;
  }

  set notiOption(bool value) {
    _prefs.setBool('NotiSetted', value);
  }

  bool get notiOption {
    return _prefs.getBool('NotiSetted') ?? true;
  }

  set firstAppOpening(bool value) {
    _prefs.setBool('firstOpening', value);
  }

  bool get firstAppOpening {
    return _prefs.getBool('firstOpening') ?? true;
  }

  set locale(String? value) {
    _prefs.setString('locale', value!);
  }

  String? get locale {
    return _prefs.getString('locale');
  }

  set startOfDay(String value) {
    _prefs.setString('startOfDay', value);
  }

  String get startOfDay {
    return _prefs.getString('startOfDay') ?? '06:00';
  }

  set endOfDay(String value) {
    _prefs.setString('endOfDay', value);
  }

  String get endOfDay {
    return _prefs.getString('endOfDay') ?? '22:00';
  }
}
