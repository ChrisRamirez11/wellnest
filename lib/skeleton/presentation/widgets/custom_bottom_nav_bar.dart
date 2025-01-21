import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/skeleton/presentation/providers/index_provider.dart';

List<BottomNavigationBarItem> itemsList = [
  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.schedule_outlined), label: 'Routines'),
  BottomNavigationBarItem(icon: Icon(Icons.health_and_safety_outlined), label: 'Wellbeing'),
  BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Achievements'),
];

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    return BottomNavigationBar(
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: primary,
        selectedItemColor: secondary,
        unselectedItemColor: obsidian,
        currentIndex: index.selectedIndex,
        onTap: (i) => index.changeIndex(i),
        items: itemsList
        );
  }
}
