import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/skeleton/presentation/widgets/custom_nav_bar.dart';

List<Widget> pages = [
  Center(child: Text('Small Routines')),
  Center(child: Text('Wellnes')),
  Center(child: Text('Week Scheduling')),
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
      bottomNavigationBar: CustomNavBar(),
      body: PageView.builder(
          controller: index.pageController,
          onPageChanged: (value) => index.changeIndex(value),
          itemBuilder: (context, index) => pages[index],
          itemCount: pages.length),
    ));
  }
}
