import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';

class RoutineTile extends ConsumerWidget {
  final int index;
  final Routine routine;
  const RoutineTile({
    super.key,
    required this.index,
    required this.routine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateNotifier = ref.watch(dateProvider);
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: routine.finished,
                    onChanged: (value) async {
                      dateNotifier.date!.routines[index].finished = value;
                      if (dateNotifier.date!.routines[index].finished!) {
                        dateNotifier.date!.completedRoutineAmount =
                            dateNotifier.date!.completedRoutineAmount + 1;
                        await dateNotifier.upsertDate(dateNotifier.date!);
                      } else {
                        dateNotifier.date!.completedRoutineAmount =
                            dateNotifier.date!.completedRoutineAmount - 1;
                        await dateNotifier.upsertDate(dateNotifier.date!);
                      }
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routine.name!),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
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
