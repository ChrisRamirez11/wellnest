import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/preferences/user_preferences.dart';

final startAndEndTimeProvider = ChangeNotifierProvider(
  (ref) => StartAndEndTimeProvider(),
);

class StartAndEndTimeProvider extends ChangeNotifier {
  final _prefs = UserPreferences();
  late String _start;
  late String _end;

  String get start => _start;
  String get end => _end;

  StartAndEndTimeProvider() {
    _start = _prefs.startOfDay;
    _end = _prefs.endOfDay;
  }

  void setStartOfDay(TimeOfDay startOfDay) {
    final parsedTime = '${startOfDay.hour}:${startOfDay.minute}';
    _prefs.startOfDay = parsedTime;
    _start = parsedTime;
    notifyListeners();
  }

  void setEndOfDay(TimeOfDay endOfDay) {
    final parsedTime = '${endOfDay.hour}:${endOfDay.minute}';
    _prefs.endOfDay = parsedTime;
    _end = parsedTime;
    notifyListeners();
  }
}
