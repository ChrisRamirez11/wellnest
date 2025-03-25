import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

class GoDeluxeButton extends StatelessWidget {
  const GoDeluxeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: CustomButton(
          icon: const Icon(
            Icons.workspace_premium,
            size: 30,
            color: Colors.white,
          ),
          onClick: () async {
            final paywall =
                await Adapty().getPaywall(placementId: 'settings_placement');
            await AdaptyUI().presentPaywallView(
                await AdaptyUI().createPaywallView(paywall: paywall));
          },
          text: 'GO DELUXE',
          color: Colors.blue,
        ));
  }
}
