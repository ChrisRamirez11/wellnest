// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';

final notificationProvider = ChangeNotifierProvider(
  (ref) => NotificationsProvider(),
);

class NotificationsProvider extends ChangeNotifier {
  late bool setted;
  final _prefs = UserPreferences();

  NotificationsProvider() {
    setted = _prefs.notiOption;
  }

  changeValue(bool value) {
    setted = value;
    _prefs.notiOption = value;
    notifyListeners();
  }
}
