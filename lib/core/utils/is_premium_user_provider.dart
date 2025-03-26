import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/purchase_observer.dart';

final isPremiumUser = ChangeNotifierProvider(
  (ref) => IsPremiumProvider(),
);

class IsPremiumProvider extends ChangeNotifier {
  bool? _isPremium;
  bool? _isLifetime;

  bool? get isPremium => _isPremium;
  bool? get isLifetime => _isLifetime;

  Future<void> premiumSetter() async {
    final adaptyProfile = await PurchasesObserver().callGetProfile();
    _isPremium = adaptyProfile?.accessLevels['premium']?.isActive ?? false;
    _isLifetime = adaptyProfile?.accessLevels['premium']?.isLifetime ?? false;
    notifyListeners();
  }
}
