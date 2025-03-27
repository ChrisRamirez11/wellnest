  import 'package:adapty_flutter/adapty_flutter.dart';

void showPaywall() async {
    final paywall =
        await Adapty().getPaywall(placementId: 'settings_placement');
    await AdaptyUI().presentPaywallView(
        await AdaptyUI().createPaywallView(paywall: paywall));
  }