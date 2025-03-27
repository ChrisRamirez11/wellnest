import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/is_premium_user_provider.dart';
import 'package:wellnest/core/utils/show_paywall.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

class GoDeluxeButton extends ConsumerWidget {
  const GoDeluxeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumNotifier = ref.watch(isPremiumUser);
    final isPremium = isPremiumNotifier.isPremium ?? false;
    final isLifetime = isPremiumNotifier.isLifetime ?? false;

    return !isLifetime
        ? SizedBox(
            width: double.infinity,
            child: CustomButton(
              icon: !isPremium
                  ? Icon(
                      Icons.workspace_premium,
                      size: 30,
                      color: Colors.white,
                    )
                  : FaIcon(
                      FontAwesomeIcons.crown,
                      size: 30,
                      color: Colors.white,
                    ),
              onClick: showPaywall,
              text: !isPremium ? 'GO DELUXE' : 'DELUXE USER',
              color: !isPremium ? Colors.blue : gold,
            ))
        : SizedBox.shrink();
  }
}
