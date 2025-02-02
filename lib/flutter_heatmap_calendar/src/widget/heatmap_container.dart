import 'package:flutter/material.dart';
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

  const HeatMapContainer({
    super.key,
    required this.date,
    this.margin,
    this.size,
    this.fontSize,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.onClick,
    this.showText,
    this.currentSelectedDate,
    this.currentSelectedDateColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(2),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? HeatMapColor.defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
          ),
          child: AnimatedContainer(
            foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                border: Border.all(
                    color: _selectedDateValidation()
                        ? currentSelectedDateColor ?? Colors.blue
                        : Colors.transparent,
                    width: 7)),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutQuad,
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 5)),
            ),
            child: (showText ?? true)
                ? Text(
                    date.day.toString(),
                    style: TextStyle(
                        color: textColor ?? const Color(0xFF8A8A8A),
                        fontWeight: FontWeight.normal,
                        fontSize: _selectedDateValidation()
                            ? fontSize! + 2
                            : fontSize),
                  )
                : null,
          ),
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
