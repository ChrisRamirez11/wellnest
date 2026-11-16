import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/theme/theme.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/feature/skeleton/presentation/providers/index_provider.dart';
import 'package:task_nest/feature/skeleton/presentation/widgets/bottom_nav_tab.dart';

class CustomNavBar extends ConsumerWidget {
  final PageController pageController;

  const CustomNavBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    return SizedBox(
      height: 65,
      child: Container(
        decoration: BoxDecoration(
          color: obsidian,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavTab(
              pageIndex: 0,
              isSelected: index.selectedIndex == 0,
              iconFilled: Icons.calendar_month,
              iconOutlined: Icons.calendar_month_outlined,
              label: localization(context).calendar,
              pageController: pageController,
            ),
            BottomNavTab(
              pageIndex: 1,
              isSelected: index.selectedIndex == 1,
              iconFilled: Icons.settings,
              iconOutlined: Icons.settings_outlined,
              label: localization(context).settings,
              pageController: pageController,
            ),
          ],
        ),
      ),
    );
  }
}
