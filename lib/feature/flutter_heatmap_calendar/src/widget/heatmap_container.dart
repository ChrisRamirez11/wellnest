import 'package:flutter/material.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/data/heatmap_color_mode.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/widget/custom_painter.dart';
import '../data/heatmap_color.dart';

class HeatMapContainer extends StatelessWidget {
  final DateTime date;
  final double? size;
  final double? fontSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final bool? showText;
  final DateTime? currentSelectedDate;
  final Color? currentSelectedDateColor;
  final Function(DateTime dateTime)? onClick;
  final ColorMode colorMode;
  final double percentCompleted;

  const HeatMapContainer(
      {super.key,
      required this.date,
      this.margin,
      this.size,
      this.fontSize,
      this.borderRadius = 5,
      this.backgroundColor,
      this.selectedColor,
      this.textColor,
      this.onClick,
      this.showText,
      this.currentSelectedDate,
      this.currentSelectedDateColor,
      required this.percentCompleted,
      required this.colorMode});

  @override
  Widget build(BuildContext context) {
    final fillColor =
        (colorMode == ColorMode.completion && percentCompleted >= 1.0)
            ? selectedColor
            : Colors.transparent;

    Widget dayCell = AnimatedContainer(
      foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular((borderRadius! + 4))),
          border: Border.all(
              strokeAlign: (percentCompleted == 1.0 || percentCompleted == 0.0)
                  ? -0.7
                  : -3.7,
              color: _selectedDateValidation()
                  ? (currentSelectedDateColor ?? Colors.yellow).withAlpha(240)
                  : Colors.transparent,
              width: (percentCompleted == 1.0 || percentCompleted == 0.0)
                  ? 9
                  : 6)),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuad,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fillColor ?? Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
      ),
      child: (showText ?? true)
          ? Text(
              date.day.toString(),
              style: TextStyle(
                  color: textColor ?? const Color(0xFF8A8A8A),
                  fontWeight: _selectedDateValidation()
                      ? FontWeight.w900
                      : FontWeight.w600,
                  fontSize:
                      _selectedDateValidation() ? fontSize! + 2 : fontSize),
            )
          : null,
    );

    if (colorMode == ColorMode.completion) {
      dayCell = CustomPaint(
        painter: CompletionBorderPainter(
          percent: percentCompleted,
          borderColor: selectedColor ?? Theme.of(context).primaryColor,
          strokeWidth: 8.0,
        ),
        child: dayCell,
      );
    }

    return Padding(
      padding: margin ?? const EdgeInsets.all(2),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? HeatMapColor.defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
          ),
          child: dayCell,
        ),
        onTap: () {
          onClick != null ? onClick!(date) : null;
        },
      ),
    );
  }

  bool _selectedDateValidation() {
    return ((date.day == (currentSelectedDate?.day ?? DateTime.now().day)) &&
        (date.month == (currentSelectedDate?.month ?? DateTime.now().month)) &&
        (date.year == (currentSelectedDate?.year ?? DateTime.now().year)));
  }
}
