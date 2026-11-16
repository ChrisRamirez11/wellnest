import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/theme/theme.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/feature/onboarding/presentation/provider/categories_provider.dart';

class SelectCategoriesScreen extends ConsumerStatefulWidget {
  const SelectCategoriesScreen({super.key});

  @override
  ConsumerState<SelectCategoriesScreen> createState() =>
      _SelectCategoriesPageState();
}

class _SelectCategoriesPageState extends ConsumerState<SelectCategoriesScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final categoriesNotifier = ref.watch(categoriesProvider);
    final routineCategories = categoriesNotifier.loadRoutines(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            localization(context).targetQuestion,
            style: textTheme(context).bodyLarge!.copyWith(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: size(context).width * 0.8,
            child: Text(
              localization(context).targetMessage,
              style: textTheme(context).labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1, // Square tiles
            ),
            itemCount: routineCategories.length,
            itemBuilder: (context, index) {
              final category = routineCategories[index];
              final isSelected = selectedIndex == index;

              if (selectedIndex == null && routineCategories.isNotEmpty) {
                final selectedCategory = ref.read(selectedCategoryProvider);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    selectedCategory != null
                        ? selectedIndex = routineCategories.indexWhere(
                            (e) => e.id == selectedCategory.id,
                          )
                        : selectedIndex = 0;
                  });
                  ref.read(selectedCategoryProvider.notifier).state =
                      routineCategories[selectedIndex ?? 0];
                });
              }

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected
                      ? BorderSide(color: ghostWhite, width: 2)
                      : BorderSide.none,
                ),
                color: isSelected ? Colors.blue.shade900 : Colors.grey.shade800,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    ref.read(selectedCategoryProvider.notifier).state =
                        category;
                  },
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          size: 40,
                          color: isSelected ? ghostWhite : category.color,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            category.name,
                            style: textTheme(context).bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
