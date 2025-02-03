import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/can_update_checkbox.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/small_routines/presentation/providers/current_selected_date_provider.dart';

class RoutineTile extends ConsumerStatefulWidget {
  final int index;
  final Routine routine;
  final bool fromRoutinesScreen;
  const RoutineTile({
    super.key,
    required this.index,
    required this.routine,
    required this.fromRoutinesScreen,
  });

  @override
  ConsumerState<RoutineTile> createState() => _RoutineTileState();
}

class _RoutineTileState extends ConsumerState<RoutineTile> {
  var width = double.maxFinite;
  var flag = true;

  @override
  Widget build(BuildContext context) {
    final dateNotifier = ref.watch(dateProvider);
    width = !flag ? size(context).width * 0.8 : size(context).width;
    return Stack(
      children: [
        backContainer(),
        frontContainer(ref, dateNotifier, context),
      ],
    );
  }

  Widget backContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(icon: Icon(Icons.edit_square), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SizedBox(width: 40, child: Divider()),
          ),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ],
      ),
    );
  }

  Widget frontContainer(
      WidgetRef ref, DateProvider dateNotifier, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.all(10),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  widget.fromRoutinesScreen
                      ? Checkbox(
                          value: widget.routine.finished,
                          //checks if date is after or same as today and if it is not, it wont let you edit it
                          onChanged: canUpdateCheckbox(ref
                                  .watch(currentSelectedDateProvider)
                                  .currentSelectedDate)
                              ? (value) async {
                                  dateNotifier.date!.routines[widget.index]
                                      .finished = value;
                                  if (dateNotifier
                                      .date!.routines[widget.index].finished!) {
                                    dateNotifier.date!.completedRoutineAmount =
                                        dateNotifier
                                                .date!.completedRoutineAmount +
                                            1;
                                    await dateNotifier
                                        .upsertDate(dateNotifier.date!);
                                  } else {
                                    dateNotifier.date!.completedRoutineAmount =
                                        dateNotifier
                                                .date!.completedRoutineAmount -
                                            1;
                                    await dateNotifier
                                        .upsertDate(dateNotifier.date!);
                                  }
                                }
                              : null,
                        )
                      : SizedBox(),
                  //ROUTINE NAME
                  Text(
                    widget.routine.name!,
                    style: textTheme(context).bodyLarge,
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  )
                ],
              ),
              getWeekDays(context)
            ],
          )),
    );
  }

  Widget getWeekDays(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        mainAxisSize:
            widget.fromRoutinesScreen ? MainAxisSize.min : MainAxisSize.max,
        children: List.generate(
          7,
          (index) => ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 10, maxWidth: 40, minHeight: 10, maxHeight: 40),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.routine.days![index] ? coffe : secondary,
              ),
              child: Center(
                child: Text(
                  DateUtil.WEEK_LABEL[index + 1],
                  style:
                      textTheme(context).bodySmall!.copyWith(color: obsidian),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
