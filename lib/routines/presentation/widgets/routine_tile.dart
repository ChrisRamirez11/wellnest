import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/can_update_checkbox.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/small_routines/presentation/providers/current_selected_date_provider.dart';

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
                    //checks if date is after or same as today and if it is not, it wont let you edit it
                    onChanged: canUpdateCheckbox(ref
                            .watch(currentSelectedDateProvider)
                            .currentSelectedDate)
                        ? (value) async {
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
                          }
                        : null,
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
