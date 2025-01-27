import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/routines/presentation/screens/routines_screen.dart';
import 'package:wellnest/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/skeleton/presentation/widgets/custom_fab.dart';
import 'package:wellnest/skeleton/presentation/widgets/custom_nav_bar.dart';

List<Widget> pages = [
  RoutinesScreen(),
  Center(child: Text('Week Scheduling')),
  Center(child: Text('Wellnes')),
  Center(child: Text('Achievements')),
];

class Skeleton extends ConsumerStatefulWidget {
  const Skeleton({super.key});

  @override
  ConsumerState<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends ConsumerState<Skeleton> {
  @override
  void dispose() {
    ref.watch(indexProvider).pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: CustomFab(),
            bottomNavigationBar: CustomNavBar(),
            body: PageView(
              controller: index.pageController,
              onPageChanged: (value) => index.changeIndex(value),
              children: pages,
            )));
  }
}
