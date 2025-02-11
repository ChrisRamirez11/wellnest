import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';

List<NavigationDestination> itemsList = [
  const NavigationDestination(
      icon: Icon(
        Icons.check_box_outlined,
        color: obsidian,
      ),
      label: 'Calendar'),
  const NavigationDestination(
      icon: Icon(
        Icons.schedule_outlined,
        color: obsidian,
      ),
      label: 'Routines'),
  const NavigationDestination(
      icon: Icon(
        Icons.person,
        color: obsidian,
      ),
      label: 'Me'),
];

class CustomNavBar extends ConsumerWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    return NavigationBar(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      animationDuration: const Duration(milliseconds: 250),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      elevation: 10,
      backgroundColor: primary,
      indicatorColor: secondary,
      destinations: itemsList,
      onDestinationSelected: (value) => index.pageController.jumpToPage(value),
      selectedIndex: index.selectedIndex,
    );
  }
}
