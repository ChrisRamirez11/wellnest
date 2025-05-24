import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/purchase_observer.dart';

final isPremiumUser = ChangeNotifierProvider(
  (ref) => IsPremiumProvider(),
);

class IsPremiumProvider extends ChangeNotifier {
  final UserPreferences _prefs = UserPreferences();
  bool? _isPremium;

  bool? get isPremium => _isPremium;

  Future<void> premiumSetter() async {
    _isPremium = _prefs.premiumUser;

    try {
      final adaptyProfile = await PurchasesObserver().callGetProfile();

      final isActive =
          adaptyProfile?.accessLevels['premium']?.isActive ?? false;
      _prefs.premiumUser = isActive;
      _isPremium = isActive;
    } catch (e) {
      debugPrint('Error obteniendo perfil de Adapty: $e');
    }

    notifyListeners();
  }
}
