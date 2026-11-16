import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/theme/theme.dart';

class BottomNavTab extends ConsumerWidget {
  final int pageIndex;
  final bool isSelected;
  final IconData iconFilled;
  final IconData iconOutlined;
  final String? label;
  final PageController pageController;

  const BottomNavTab({
    super.key,
    required this.pageIndex,
    required this.isSelected,
    required this.iconFilled,
    required this.iconOutlined,
    required this.pageController,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 250), curve: Curves.easeOut),
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
