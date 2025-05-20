import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/ai_coach/presentation/screens/coach_chat_screen.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';

class CustomNavBar extends ConsumerStatefulWidget {
  const CustomNavBar({super.key});

  @override
  ConsumerState<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends ConsumerState<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);

    return SizedBox(
      height: 70,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: obsidian,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
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
                const SizedBox(width: 10),
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
              onTap: () async {
                Vibration.vibrate();//TODO Like Threads
                await Navigator.of(context).push(
                  PageRouteBuilder(
                      //TODO MOVE
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const CoachChatScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0); // desde abajo
                        const end = Offset.zero;
                        const curve = Curves.easeOut;

                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                      reverseTransitionDuration: Duration(milliseconds: 150)),
                );
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
