import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';

class CustomAppBar extends AppBar {
  final String titleString;
  final List<Widget>? actionsList;
  final Widget? leadingWidget;
  CustomAppBar({super.key, required this.titleString, this.actionsList, this.leadingWidget})
      : super(
          foregroundColor: secondary,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: titleWidget(titleString),
          actions: actionsList,
          leading: leadingWidget
        );

  static Text titleWidget(String titleString) {
    return Text(
          titleString,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
  }
}
