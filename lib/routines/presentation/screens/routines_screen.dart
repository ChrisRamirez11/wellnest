import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider).routines;
    final failure = ref.watch(routineProvider).failure;
    late Widget? widget;

    if (routines != null) {
      widget = Scaffold(
        body: ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(routines[index].name),
          ),
        ),
      );
    } else if (failure != null) {
      widget = Center(
        child: Text('Error'),
      );
    } else {
      widget = Center(
        child: CircularProgressIndicator(),
      );
    }
    return widget;
  }
}
