import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/delete_routine_date_today.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/feature/calendar/presentation/providers/current_selected_date_provider.dart';

class RoutineTile extends ConsumerStatefulWidget {
  final RoutineModel routine;
  const RoutineTile({
    super.key,
    required this.routine,
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
      color: Colors.transparent,
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
                icon: Icon(
                  Icons.edit_square,
                  color: !flag ? ghostWhite : Colors.transparent,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateRoutineScreen(
                          routineModel: widget.routine,
                        ),
                      ));
                }),
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: SizedBox(
                  width: 40,
                  child: Divider(
                    color: !flag ? ghostWhite : Colors.transparent,
                  )),
            ),
            IconButton(
                highlightColor: ghostWhite.withAlpha(100),
                icon: Icon(
                  Icons.delete,
                  color: !flag ? ghostWhite : Colors.transparent,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => getDeletionDialog(context),
                  );
                }),
          ],
        ),
      ),
    );
  }

  SimpleDialog getDeletionDialog(BuildContext context) {
    return SimpleDialog(
      title: Text(
        localization(context).deleteReoutineQuestion,
        style: textTheme(context).bodyMedium,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            localization(context).deleteReoutineAwareness,
            style: textTheme(context).bodySmall!.copyWith(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 15),
          child: Row(
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    localization(context).cancel,
                    style: textTheme(context).bodyMedium,
                  )),
              Spacer(),
              TextButton(
                  onPressed: () async {
                    //update the selected date to today
                    ref
                        .watch(currentSelectedDateProvider)
                        .changeDate(DateTime.now());

                    setState(() {
                      flag = !flag;
                    });

                    //Cancels the notification of the routine if have any
                    await NotiService()
                        .cancelNotificationById(widget.routine.id!);

                    await ref
                        .watch(routineProvider)
                        .deleteRoutine(widget.routine.id!);
                    //deletes the routine for today if it exists
                    await deleteRoutineDateToday(
                        ref, Routine.fromModel(widget.routine));

                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Text(
                    localization(context).delete,
                    style: textTheme(context)
                        .bodyMedium!
                        .copyWith(color: errorColor),
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget frontContainer(
      WidgetRef ref, DateProvider dateNotifier, BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      bottom: 0,
      top: 0,
      left: 0,
      right: !flag ? width * 0.25 : 0,
      child: Card(
        color: Color(widget.routine.colorValue).withAlpha(170),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(10),
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 15,
              children: [
                Row(
                  children: [
                    //ROUTINE NAME
                    Column(
                      spacing: 5,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          width: flag
                              ? size(context).width * .65
                              : size(context).width * .4,
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: widget.routine.name,
                            showDuration: Duration(seconds: 5),
                            decoration: BoxDecoration(
                                color: obsidian,
                                borderRadius: BorderRadius.circular(5)),
                            textStyle: textTheme(context)
                                .labelMedium!
                                .copyWith(color: secondary),
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              widget.routine.name,
                              maxLines: 1,
                              style: textTheme(context)
                                  .bodyLarge!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                        //ROUTINE TYPE
                        AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          width: flag
                              ? size(context).width * .65
                              : size(context).width * .4,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            _getRoutineTypeText(context, widget.routine.type),
                            maxLines: 1,
                            style: textTheme(context)
                                .bodySmall!
                                .copyWith(color: Colors.grey.shade400),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      icon: const Icon(
                        Icons.more_horiz,
                      ),
                      onPressed: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                    )
                  ],
                ),
                FittedBox(
                  child: getWeekDays(context),
                )
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
        mainAxisSize: MainAxisSize.max,
        children: List.generate(
          7,
          (index) => ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 10, maxWidth: 40, minHeight: 10, maxHeight: 40),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.routine.days[index]
                    ? Color(widget.routine.colorValue).withAlpha(120)
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  DateUtil(ref).weekLabel[index][0].toUpperCase(),
                  style: textTheme(context).bodySmall!.copyWith(
                        color: secondary,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRoutineTypeText(BuildContext context, String type) {
    switch (RoutineType.values.byName(type)) {
      case RoutineType.task:
        return localization(context).task;

      case RoutineType.amount:
        return localization(context).amount;

      case RoutineType.timed:
        return localization(context).timeRoutine;
    }
  }
}
