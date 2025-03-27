import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/widgets/routine_model_tile.dart';
import 'package:wellnest/core/widgets/custom_fab.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesNotifier = ref.watch(routineProvider);
    final failure = routinesNotifier.failure;
    final routines = routinesNotifier.routines;
    late Widget widget;
    if (failure != null) {
      widget = Center(child: Text('Error: $failure'));
    } else if (routines != null) {
      widget = Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) {
            return RoutineTile(
              routine: routines[index],
              index: index,
            );
          },
        ),
      );
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }

    final showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: CustomAppBar(titleString: 'ROUTINES'),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: showFab ? const CustomFab() : const SizedBox(),
      body: widget,
    );
  }
}
