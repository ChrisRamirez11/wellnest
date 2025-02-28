import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
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
            onClick: () {},
            text: 'GO DELUXE',
            color: secondary.withAlpha(150),
          ));
  }
}