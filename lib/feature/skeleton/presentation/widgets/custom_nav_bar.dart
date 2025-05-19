import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';

class CustomNavBar extends ConsumerWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    return Stack(
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
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Contenido del BottomSheet"),
                ),
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
