import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/routines/presentation/providers/categories_provider.dart';

class SelectRoutinesScreen extends ConsumerWidget {
  const SelectRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedRoutineNames = ref.watch(selectedRoutinesProvider);

    if (selectedCategory == null) {
      return Center(child: Text('No category selected'));
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: selectedCategory.routines.length,
        itemBuilder: (context, index) {
          final routine = selectedCategory.routines[index];
          final isSelected = selectedRoutineNames.contains(routine.name);

          return ListTile(
            title: Text(routine.name),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            onTap: () {
              final notifier = ref.read(selectedRoutinesProvider.notifier);
              if (isSelected) {
                notifier.state = selectedRoutineNames
                    .where((name) => name != routine.name)
                    .toList();
              } else {
                notifier.state = [...selectedRoutineNames, routine.name];
              }
            },
          );
        },
      ),
    );
  }
}
