import 'package:flutter/material.dart';
import 'package:task_nest/core/theme/theme.dart';
import 'package:task_nest/core/utils/utils.dart';

class CustomBorderButton extends StatelessWidget {
  const CustomBorderButton({
    super.key,
    required this.onClick,
    required this.text,
    this.textColor,
    this.radius,
    this.color,
    this.icon,
    this.borderWidth = 1,
    this.alpha = 30, // Nuevo parámetro para controlar la transparencia
  });

  final Function()? onClick;
  final Color? textColor;
  final double? radius;
  final Widget? icon;
  final Color? color;
  final String text;
  final double borderWidth;
  final int alpha; // Nuevo parámetro (valor entre 0 y 255)

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).primaryColor;
    final txtColor = textColor ?? secondary;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 65,
        maxHeight: 120,
        minWidth: 200,
        maxWidth: 250,
      ),
      child: OutlinedButton.icon(
        icon: icon ?? const SizedBox(width: 0, height: 0),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            buttonColor.withAlpha(
                alpha.clamp(0, 255)), // Usamos el alpha proporcionado
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: buttonColor, width: borderWidth),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 100),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return buttonColor.withAlpha(alpha ~/ 2); // Efecto al presionar
              }
              return Colors.transparent;
            },
          ),
        ),
        onPressed: onClick,
        label: FittedBox(
          child: Text(
            text,
            style: textTheme(context).bodyLarge?.copyWith(
                  color: txtColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
