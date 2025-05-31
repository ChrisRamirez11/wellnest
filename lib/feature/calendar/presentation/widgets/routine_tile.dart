import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/can_update_checkbox.dart';
import 'package:wellnest/core/utils/format_duration.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';
import 'package:wellnest/feature/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/feature/calendar/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/feature/calendar/presentation/screens/countdown_page.dart';

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
    color = widget.routine.finished!
        ? Color(widget.routine.colorValue!).withAlpha(200)
        : Colors.transparent;
    final dateNotifier = ref.watch(dateProvider);
    width = !flag ? size(context).width * 0.8 : size(context).width;
    return Stack(
      children: [backContainer(), frontContainer(ref, dateNotifier, context)],
    );
  }

  Widget getControlWidget(DateProvider dateNotifier) {
    final type = widget.routine.type ?? RoutineType.task.name;
    final canUpdate = canUpdateCheckbox(
        ref.watch(currentSelectedDateProvider).currentSelectedDate);
    final routine = dateNotifier.date!.routines[widget.index];

    Future<void> handleComplete(bool completed) async {
      if (!canUpdate) return;

      _routineCompletedAnimation(completed);
      setState(() {
        routine.finished = completed;
        color = completed
            ? Color(widget.routine.colorValue!).withAlpha(200)
            : Colors.transparent;
      });

      dateNotifier.date!.completedRoutineAmount =
          _getCompletedQuantity(dateNotifier);
      await dateNotifier.upsertDate(dateNotifier.date!);
    }

    Future<void> handleAmountComplete() async {
      if (!canUpdate) return;

      setState(() {
        routine.currentCount = routine.targetCount;
      });
      await handleComplete(true);
    }

    Future<void> handleAmountIncrement() async {
      if (!canUpdate || routine.finished!) return;

      if (routine.currentCount! < routine.targetCount!) {
        setState(() {
          routine.currentCount = routine.currentCount! + 1;
        });

        if (routine.currentCount! >= routine.targetCount!) {
          await handleComplete(true);
        } else {
          await dateNotifier.upsertDate(dateNotifier.date!);
        }
      }
    }

    Future<void> handleTimedComplete() async {
      if (!canUpdate) return;

      setState(() {
        routine.elapsedTimeSeconds = routine.targetDurationSeconds;
      });
      await handleComplete(true);
    }

    Future<void> handleTimedStart() async {
      if (!canUpdate) return;

      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => CountdownPage(
            routine: widget.routine,
            routineIndex: widget.index,
          ),
        ),
      );

      if (result == true) {
        await handleComplete(true);
      } else {
        dateNotifier.date!.completedRoutineAmount =
            _getCompletedQuantity(dateNotifier);
        await dateNotifier.upsertDate(dateNotifier.date!);
      }
    }

    switch (RoutineType.values.byName(type)) {
      case RoutineType.task:
        return Checkbox(
          fillColor: WidgetStatePropertyAll(
              widget.routine.finished! ? ghostWhite.withAlpha(150) : null),
          value: widget.routine.finished,
          onChanged: canUpdate ? (value) => handleComplete(value!) : null,
        );

      case RoutineType.amount:
        return Row(
          children: [
            GestureDetector(
              onLongPress: canUpdate ? handleAmountComplete : null,
              child: IconButton(
                icon: const Icon(Icons.add, color: ghostWhite),
                onPressed: canUpdate ? handleAmountIncrement : null,
              ),
            ),
          ],
        );

      case RoutineType.timed:
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: ghostWhite),
              onLongPress: canUpdate ? handleTimedComplete : null,
              onPressed: canUpdate ? handleTimedStart : null,
            ),
          ],
        );
    }
  }

  Widget backContainer() {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 110, maxHeight: 200),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                highlightColor: ghostWhite.withAlpha(100),
                icon: Icon(
                  Icons.undo,
                  color: !flag
                      ? widget.routine.finished!
                          ? ghostWhite
                          : ghostWhite.withAlpha(
                              80) // Más transparente cuando está deshabilitado
                      : Colors.transparent,
                ),
                onPressed: !flag && widget.routine.finished!
                    ? () async {
                        final dateNotifier = ref.read(dateProvider);
                        await _undoRoutine(dateNotifier);
                        setState(() {
                          flag =
                              true; // Cierra el contenedor después de deshacer
                        });
                      }
                    : null,
              ),
              IconButton(
                highlightColor: ghostWhite.withAlpha(100),
                icon: Icon(
                  Icons.edit_square,
                  color: !flag ? ghostWhite : Colors.transparent,
                ),
                onPressed: !flag
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRoutineScreen(
                              routineModel: widget.routine.toModel(),
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _undoRoutine(DateProvider dateNotifier) async {
    final routine = dateNotifier.date!.routines[widget.index];
    final type =
        RoutineType.values.byName(routine.type ?? RoutineType.task.name);

    switch (type) {
      case RoutineType.task:
        // For tasks, just toggle the finished state back
        routine.finished = !routine.finished!;
        color = routine.finished!
            ? Color(routine.colorValue!).withAlpha(200)
            : Colors.transparent;
        break;

      case RoutineType.amount:
        // For amount routines, decrement the count or reset if finished
        routine.finished = false;
        routine.currentCount = 0;
        color = Colors.transparent;
        break;

      case RoutineType.timed:
        // For timed routines, reset the elapsed time if finished
        routine.finished = false;
        routine.elapsedTimeSeconds = 0;
        color = Colors.transparent;
        break;
    }

    dateNotifier.date!.completedRoutineAmount =
        _getCompletedQuantity(dateNotifier);
    await dateNotifier.upsertDate(dateNotifier.date!);
    setState(() {});
  }

  Widget frontContainer(
      WidgetRef ref, DateProvider dateNotifier, BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      bottom: 0,
      top: 0,
      left: 0,
      right: !flag ? width * 0.20 : 0,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              color: color,
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  getControlWidget(dateNotifier),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        width: flag
                            ? size(context).width * .50
                            : size(context).width * .30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Tooltip(
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
                                widget.routine.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme(context).bodyLarge!.copyWith(
                                      fontSize: 18,
                                      color: widget.routine.finished!
                                          ? ghostWhite.withAlpha(150)
                                          : null,
                                    ),
                              ),
                            ),
                            if (widget.routine.type != RoutineType.task.name)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: _buildProgressIndicator(dateNotifier),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _getTrailing()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTrailing() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = ref.watch(currentSelectedDateProvider).currentSelectedDate;
    final isBefore = date.isBefore(today);

    return isBefore
        ? SizedBox.shrink()
        : IconButton(
            icon: const Icon(Icons.more_horiz, color: ghostWhite),
            onPressed: () {
              setState(() {
                flag = !flag;
              });
            },
          );
  }

  Widget _buildProgressIndicator(DateProvider dateNotifier) {
    final routine = widget.routine;
    final textStyle = textTheme(context).bodySmall!.copyWith(
          color: ghostWhite.withAlpha(150),
        );

    switch (RoutineType.values.byName(routine.type!)) {
      case RoutineType.amount:
        return Text(
          '${routine.currentCount}/${routine.targetCount}',
          style: textStyle,
        );
      case RoutineType.timed:
        return Row(
          children: [
            Text(
              formatDuration(routine.elapsedTimeSeconds!),
              style: textStyle,
            ),
            Text(
              ' / ${formatDuration(routine.targetDurationSeconds!)}',
              style: textStyle,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  int _getCompletedQuantity(DateProvider dateNotifier) {
    int result = 0;
    for (var routine in dateNotifier.date!.routines) {
      result += routine.finished! ? 1 : 0;
    }
    return result;
  }

  Future<void> _routineCompletedAnimation(bool value) async {
    setState(() {
      scale = value ? 1.05 : 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      scale = 1.0;
    });
  }
}
