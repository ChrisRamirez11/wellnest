import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';

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