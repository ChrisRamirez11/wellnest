import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';

class CustomAppBar extends AppBar {
  final String titleString;
  final List<Widget>? actionsList;
  CustomAppBar({super.key, required this.titleString, this.actionsList,})
      : super(
          foregroundColor: secondary,
          title: titleWidget(titleString),
          actions: actionsList
        );

  static Text titleWidget(String titleString) {
    return Text(
          titleString,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
  }
}
