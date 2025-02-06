import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/routines/presentation/widgets/routine_tile.dart';

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
      widget = ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          return RoutineTile(
              routine: Routine.fromModel(routines[index]), index: index, fromRoutinesScreen: false,);
        },
      );
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CustomAppBar(titleString: 'Routines'),
      body: widget,
    );
  }
}
