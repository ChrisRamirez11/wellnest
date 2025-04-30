import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';

final globalNotiIdsProvider = ChangeNotifierProvider<GlobalNotiIds>((ref) {
  return GlobalNotiIds();
});

class GlobalNotiIds extends ChangeNotifier {
  final _prefs = UserPreferences();

  late int _morningId;
  late int _nightId;

  GlobalNotiIds() {
    _morningId = _prefs.morningNotiId;
    _nightId = _prefs.nightNotiId;
    _setIDs();
  }

  int get morningId => _morningId;
  int get nightId => _nightId;

  void _setIDs() {
    _prefs.morningNotiId = _morningId;
    _prefs.nightNotiId = _nightId;
    notifyListeners();
  }
}
