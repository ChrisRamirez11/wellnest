import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/delete_routine_date_today.dart';
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
  const RoutineTile({
    super.key,
    required this.index,
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
        'Are you sure to delete this routine?',
        style: textTheme(context).bodyMedium,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Deleting this routine will simply remove it from your routines list.',
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
                    'Cancel',
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
                    
                    await ref
                        .watch(routineProvider)
                        .deleteRoutine(widget.routine.id!);
                    //deletes the routine for today if it exists
                    await deleteRoutineDateToday(ref, widget.routine);

                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
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
      duration: const Duration(milliseconds: 200),
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
                    //ROUTINE NAME
                    AnimatedContainer(
                      duration: Duration(milliseconds: 210),
                      width: flag
                          ? size(context).width * .65
                          : size(context).width * .4,
                      child: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: widget.routine.name,
                        showDuration: Duration(seconds: 5),
                        decoration: BoxDecoration(color: obsidian),
                        textStyle: textTheme(context)
                            .labelMedium!
                            .copyWith(color: secondary),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          widget.routine.name!,
                          maxLines: 1,
                          style: textTheme(context)
                              .bodyLarge!
                              .copyWith(fontSize: 18),
                        ),
                      ),
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
                color:
                    widget.routine.days![index] ? primary : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  DateUtil.WEEK_LABEL[index + 1][0].toUpperCase(),
                  style:
                      textTheme(context).bodySmall!.copyWith(color: secondary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
