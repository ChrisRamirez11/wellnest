import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/routines/data/models/routine/routine_model.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';

class RoutineTile extends ConsumerWidget {
  final RoutineModel routineModel;
  const RoutineTile({
    super.key,
    required this.routineModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineNotifier = ref.watch(routineProvider);
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: routineModel.finished,
                    onChanged: (value) async {
                      routineModel.finished = value!;
                      await routineNotifier.upsertRoutine(routineModel);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routineModel.name),
                    ],
                  ),
                  Expanded(child: const SizedBox()),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      //TODO
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
