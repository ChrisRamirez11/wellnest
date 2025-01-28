import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/routines/data/models/routine/routine_model.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';

class CustomFab extends ConsumerWidget {
  const CustomFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async => ref.watch(routineProvider).upsertRoutine(
            RoutineModel(
                createdDate: DateTime.now(),
                name: 'Meditacion',
                finished: false,
                days: [false, false, true, false, false, false, false])),
        child: Icon(Icons.add));
  }
}
