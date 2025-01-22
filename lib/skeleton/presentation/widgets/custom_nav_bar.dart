import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/skeleton/presentation/providers/index_provider.dart';

List<NavigationDestination> itemsList = [
  NavigationDestination(icon: Icon(Icons.check_box), label: 'Small Routines'),
  NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: 'Wellness'),
  NavigationDestination(icon: Icon(Icons.schedule_outlined), label: 'Week Scheduling'),
  NavigationDestination(icon: Icon(Icons.star_border), label: 'Achievements'),
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
      onDestinationSelected: (value) => index.updatePageController(value),
      selectedIndex: index.selectedIndex,
    );
  }
}
