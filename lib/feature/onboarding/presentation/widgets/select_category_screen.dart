import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/routines/data/models/routine_category.dart';
import 'package:wellnest/feature/routines/presentation/providers/categories_provider.dart';

class SelectCategoriesScreen extends ConsumerStatefulWidget {
  final void Function(RoutineCategory) onCategorySelected;

  const SelectCategoriesScreen({super.key, required this.onCategorySelected});

  @override
  ConsumerState<SelectCategoriesScreen> createState() =>
      _SelectCategoriesPageState();
}

class _SelectCategoriesPageState extends ConsumerState<SelectCategoriesScreen> {
  int? selectedIndex;

  // Helper function to get IconData from icon name
  IconData? _getIconDataFromName(String iconName) {
    switch (iconName) {
      case 'fitness_center':
        return Icons.fitness_center;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'flag':
        return Icons.flag;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'spa':
        return Icons.spa;
      // Add more cases as needed
      default:
        return Icons.category; // Default icon if not found
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      body: categoriesAsync.when(
        data: (categories) {
          // Automatically select the first item when data loads
          if (selectedIndex == null && categories.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedIndex = 0;
              });
              widget.onCategorySelected(categories[0]);
            });
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1, // Square tiles
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onCategorySelected(category);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: Colors.blue, width: 2)
                        : BorderSide.none,
                  ),
                  color: isSelected ? Colors.blue : Colors.grey.shade800,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconDataFromName(category.icon),
                        size: 40,
                        color: isSelected ? ghostWhite : category.color,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          category.name,
                          style:
                              textTheme(context).bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
