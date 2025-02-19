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
    _prefs.setBool('NotiSetted', value);
  }

  bool get firstTimeNotiSetted {
    return _prefs.getBool('NotiSetted') ?? false;
  }

  set notiOption(bool value) {
    _prefs.setBool('NotiSetted', value);
  }

  bool get notiOption {
    return _prefs.getBool('NotiSetted') ?? true;
  }
}
