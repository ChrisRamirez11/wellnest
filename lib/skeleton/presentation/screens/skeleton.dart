import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/skeleton/presentation/widgets/custom_bottom_nav_bar.dart';

List<Widget> pages = [
  Center(child: Text('Home')),
  Center(child: Text('Routines')),
  Center(child: Text('Wellbeing')),
  Center(child: Text('Achievements')),
];


class Skeleton extends ConsumerWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      body: pages[index.selectedIndex],
    ));
  }
}
