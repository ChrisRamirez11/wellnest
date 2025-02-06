import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();
  factory UserPreferences() {
    return _instancia;
  }
  UserPreferences._internal();
  late SharedPreferences _prefs;
  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set darkMode(bool value) {
    _prefs.setBool('DarkMode', value);
  }

  bool get darkMode {
    return _prefs.getBool('DarkMode') ?? true;
  }

}
