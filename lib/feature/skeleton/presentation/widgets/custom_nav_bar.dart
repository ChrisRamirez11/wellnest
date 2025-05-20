import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/ai_coach/presentation/screens/coach_chat_screen.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/nav_bar_visiblity.dart';

class CustomNavBar extends ConsumerWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    final navBarVisible = ref.watch(navBarVisibleProvider);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: navBarVisible ? 0 : null, //control the visibility of the NavBar
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: obsidian,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
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
                ),
                const SizedBox(width: 10), // space for the central button
                BottomNavTab(
                  pageIndex: 1,
                  isSelected: index.selectedIndex == 1,
                  iconFilled: Icons.person,
                  iconOutlined: Icons.person_outline,
                ),
              ],
            ),
          ),

          // Central floating button
          Positioned(
            bottom: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                showBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => CoachChatScreen(),
                );
                ref.watch(navBarVisibleProvider.notifier).state =
                    !navBarVisible;
              },
              child: Container(
                height: 60,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.circle, color: ghostWhite, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavTab extends ConsumerWidget {
  final int pageIndex;
  final bool isSelected;
  final IconData iconFilled;
  final IconData iconOutlined;
  final String? label;

  const BottomNavTab({
    super.key,
    required this.pageIndex,
    required this.isSelected,
    required this.iconFilled,
    required this.iconOutlined,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(indexProvider).pageController.jumpToPage(pageIndex),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? iconFilled : iconOutlined,
            color: isSelected ? ghostWhite : Colors.grey.shade600,
            size: 35,
          ),
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? ghostWhite : Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }
}
