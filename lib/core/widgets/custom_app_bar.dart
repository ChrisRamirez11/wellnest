import 'package:flutter/material.dart';
import 'package:task_nest/core/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleString;
  final List<Widget>? actionsList;
  final Widget? leadingWidget;

  const CustomAppBar({
    super.key,
    required this.titleString,
    this.actionsList,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: secondary,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: _titleWidget(titleString),
      actions: actionsList,
      leading: leadingWidget,
    );
  }

  static Text _titleWidget(String titleString) {
    return Text(
      titleString,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
