import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  late SharedPreferencesWithCache _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
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

  int get morningNotiId {
    return _prefs.getInt('morningNotiId') ?? UniqueKey().hashCode;
  }

  set morningNotiId(int value) {
    _prefs.setInt('morningNotiId', value);
  }

  int get nightNotiId {
    return _prefs.getInt('nightNotiId') ?? UniqueKey().hashCode;
  }

  set nightNotiId(int value) {
    _prefs.setInt('nightNotiId', value);
  }

  bool get batteryPermissionAsked {
    return _prefs.getBool('batteryPermissionAsked') ?? false;
  }

  set batteryPermissionAsked(bool value) {
    _prefs.setBool('batteryPermissionAsked', value);
  }

  set firstAppOpening(bool value) {
    _prefs.setBool('firstOpening', value);
  }

  bool get firstAppOpening {
    return _prefs.getBool('firstOpening') ?? true;
  }

  set calendarVisibility(bool value) {
    _prefs.setBool('calendarVisibility', value);
  }

  bool get calendarVisibility {
    return _prefs.getBool('calendarVisibility') ?? true;
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
