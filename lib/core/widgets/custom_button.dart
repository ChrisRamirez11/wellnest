import 'package:flutter/material.dart';
import 'package:wellnest/core/utils/utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onClick,
    required this.text,
    this.textColor,
    this.color,
  });

  final Function() onClick;
  final String text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 70,
        maxHeight: 120,
        minWidth: 200,
        maxWidth: 250,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)))),
        onPressed: onClick,
        child: Text(
          text,
          style: textTheme(context)
              .bodyLarge!
              .copyWith(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
