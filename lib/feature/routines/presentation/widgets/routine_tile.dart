import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/can_update_checkbox.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/feature/small_routines/presentation/providers/current_selected_date_provider.dart';

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
    return Card(
      color: obsidian,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                highlightColor: ghostWhite.withAlpha(100),
                icon: const Icon(
                  Icons.edit_square,
                  color: ghostWhite,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateRoutineScreen(
                          routineModel: widget.routine.toModel(),
                        ),
                      ));
                }),
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: SizedBox(width: 40, child: Divider()),
            ),
            IconButton(
                highlightColor: ghostWhite.withAlpha(100),
                icon: const Icon(
                  Icons.delete,
                  color: ghostWhite,
                ),
                onPressed: () async {
//TODO Place a dialog telling the user that it will delete the routine from the DB,
//and if you want to deleted from the current date, just edit it.
                  await ref
                      .watch(routineProvider)
                      .deleteRoutine(widget.routine.id!);
                }),
          ],
        ),
      ),
    );
  }

  Widget frontContainer(
      WidgetRef ref, DateProvider dateNotifier, BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      bottom: 0,
      top: 0,
      left: 0,
      right: !flag ? width * 0.25 : 0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(10),
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 15,
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
                                    dateNotifier.date!.completedRoutineAmount =
                                        _getCompletedQuantity(dateNotifier);
                                    await dateNotifier
                                        .upsertDate(dateNotifier.date!);
                                  }
                                : null,
                          )
                        : const SizedBox(),
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
      ),
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
                color: widget.routine.days![index] ? primary : catColor,
              ),
              child: Center(
                child: Text(
                  DateUtil.WEEK_LABEL[index + 1][0].toUpperCase(),
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

  int _getCompletedQuantity(DateProvider dateNotifier) {
    int result = 0;
    for (var routine in dateNotifier.date!.routines) {
      result += routine.finished! ? 1 : 0;
    }
    return result;
  }
}
