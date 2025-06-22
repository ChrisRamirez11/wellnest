import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';

final calendarVisibilityProvider = StateNotifierProvider<CalendarVisibilityProvider, bool>(
  (ref) => CalendarVisibilityProvider(),
);

class CalendarVisibilityProvider extends StateNotifier<bool> {
  final _prefs = UserPreferences();

  CalendarVisibilityProvider() : super(false) {
    _loadVisibility();
  }

  void _loadVisibility() {
    state = _prefs.calendarVisibility;
  }

  void toggleVisibility() {
    state = !state;
    _prefs.calendarVisibility = state;
  }
}