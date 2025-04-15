import 'package:flutter/material.dart';
import 'package:wellnest/core/utils/utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onClick,
    required this.text,
    this.textColor,
    this.radius,
    this.color,
    this.icon,
  });

  final Function()? onClick;
  final Color? textColor;
  final double? radius;
  final Widget? icon;
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 65,
        maxHeight: 120,
        minWidth: 200,
        maxWidth: 250,
      ),
      child: ElevatedButton.icon(
        icon: icon ?? const SizedBox(),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 100)))),
        onPressed: onClick,
        label: FittedBox(
          child: Text(
            text,
            style: textTheme(context).bodyLarge!.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
