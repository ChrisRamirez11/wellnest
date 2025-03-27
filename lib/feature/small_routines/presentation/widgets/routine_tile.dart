import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/can_update_checkbox.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/feature/small_routines/presentation/providers/current_selected_date_provider.dart';

class SmallRoutineTile extends ConsumerStatefulWidget {
  final int index;
  final Routine routine;
  
  const SmallRoutineTile({
    super.key,
    required this.index,
    required this.routine,
  });

  @override
  ConsumerState<SmallRoutineTile> createState() => _RoutineTileState();
}

class _RoutineTileState extends ConsumerState<SmallRoutineTile> {
  var width = double.maxFinite;
  var flag = true;
  double scale = 1.0;
  Color color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    color = widget.routine.finished! ? Colors.brown : Colors.transparent;
    final dateNotifier = ref.watch(dateProvider);
    width = !flag ? size(context).width * 0.8 : size(context).width;
    return Stack(
      children: [backContainer(), frontContainer(ref, dateNotifier, context)],
    );
  }

  Checkbox getCheckbox(DateProvider dateNotifier) {
    return Checkbox(
      fillColor: WidgetStatePropertyAll(widget.routine.finished! ? ghostWhite.withAlpha(150) : null),
      value: widget.routine.finished,
      onChanged: canUpdateCheckbox(
              ref.watch(currentSelectedDateProvider).currentSelectedDate)
          ? (value) async {
              setState(() {
                scale = value! ? 1.05 : 0.95;
              });
              await Future.delayed(const Duration(milliseconds: 200));
              setState(() {
                scale = 1.0;
              });
              //Handles the color change
              color = value! ? Colors.brown : Colors.transparent;

              dateNotifier.date!.routines[widget.index].finished = value;
              dateNotifier.date!.completedRoutineAmount =
                  _getCompletedQuantity(dateNotifier);
              await dateNotifier.upsertDate(dateNotifier.date!);
            }
          : null,
    );
  }

  Widget backContainer() {
    return Card(
      color: obsidian,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 110, maxHeight: 200),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
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
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 220),
        curve: Curves.linear,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
            color: color,
            duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      getCheckbox(dateNotifier),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 210),
                          width: flag
                              ? size(context).width * .50
                              : size(context).width * .30,
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: widget.routine.name,
                            showDuration: Duration(seconds: 5),
                            decoration: BoxDecoration(color: obsidian),
                            textStyle: textTheme(context)
                                .labelMedium!
                                .copyWith(color: secondary),
                            child: Text(
                              widget.routine.finished!
                                  ? '  ${widget.routine.name!}${'\u00A0' * 2}'
                                  : widget.routine.name!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme(context).bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: widget.routine.finished!
                                      ? ghostWhite.withAlpha(150)
                                      : null,
                                  decorationThickness: 2,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: widget.routine.finished!
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: ghostWhite,),
                        onPressed: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                      )
                    ],
                  ),
                ],
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
