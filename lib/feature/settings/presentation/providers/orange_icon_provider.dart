import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';

final orangeIconProvider =
    StateNotifierProvider<OrangeIconProvider, bool>((ref) {
  return OrangeIconProvider();
});

class OrangeIconProvider extends StateNotifier<bool> {
  final _prefs = UserPreferences();

  OrangeIconProvider() : super(false) {
    // Initialize state from preferences
    state = _prefs.hasSeenOrangeIcon;
  }

  bool get currentState => state;

  void setHasSeenOrangeIcon() {
    _prefs.hasSeenOrangeIcon = true;
    state = true;
  }

  void reset() {
    _prefs.hasSeenOrangeIcon = false;
    state = false;
  }
}
