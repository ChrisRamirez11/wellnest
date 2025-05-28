import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/global_providers/is_premium_user_provider.dart';
import 'package:wellnest/core/utils/show_paywall.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

class GoDeluxeButton extends ConsumerWidget {
  const GoDeluxeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumNotifier = ref.watch(isPremiumUser);
    final isPremium = isPremiumNotifier.isPremium ?? false;

    return SizedBox(
        width: double.infinity,
        child: CustomButton(
          radius: 10,
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
          onClick: !isPremium ? showPaywall : null,
          text: !isPremium
              ? localization(context).goDeluxe.toUpperCase()
              : localization(context).premiumUser.toUpperCase(),
          color: !isPremium ? gold.withAlpha(170) : gold.withAlpha(230),
        ));
  }
}
