import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';

class CustomAppBar extends AppBar {
  final String titleString;
  CustomAppBar({super.key, required this.titleString})
      : super(
          foregroundColor: secondary,
          title: titleWidget(titleString),
        );

  static Text titleWidget(String titleString) {
    return Text(
          titleString,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
  }
}
