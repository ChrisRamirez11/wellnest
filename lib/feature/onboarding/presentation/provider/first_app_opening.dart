import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/preferences/user_preferences.dart';

final firstTimeOpening = ChangeNotifierProvider(
  (ref) => FirstAppOpening(),
);

class FirstAppOpening extends ChangeNotifier {
  final _prefs = UserPreferences();
  late bool _firstTimeOpening;

  FirstAppOpening() {
    _firstTimeOpening = _prefs.firstAppOpening;
  }

  bool get firstTimeOpening => _firstTimeOpening;

  void appOpened() {
    _prefs.firstAppOpening = false;
    _firstTimeOpening = _prefs.firstAppOpening;
  }
}
