import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/categories_provider.dart';

class SelectRoutinesScreen extends ConsumerWidget {
  const SelectRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedRoutineNames = ref.watch(selectedRoutinesProvider);

    if (selectedCategory == null) {
      return Center(child: Text('No category selected'));
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: selectedCategory.routines.length,
        itemBuilder: (context, index) {
          final routine = selectedCategory.routines[index];
          final isSelected = selectedRoutineNames.contains(routine.name);

          return Card(
            color: isSelected
                ? Colors.blue.shade900
                : Colors.grey.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            margin: const EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                final notifier = ref.read(selectedRoutinesProvider.notifier);
                if (isSelected) {
                  notifier.state = selectedRoutineNames
                      .where((name) => name != routine.name)
                      .toList();
                } else {
                  notifier.state = [...selectedRoutineNames, routine.name];
                }
              },
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
                              SizedBox(
                                width: size(context).width * .65,
                                child: Tooltip(
                                  enableFeedback: false,
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: routine.name,
                                  showDuration: Duration(seconds: 5),
                                  decoration: BoxDecoration(
                                      color: obsidian,
                                      borderRadius: BorderRadius.circular(5)),
                                  textStyle: textTheme(context)
                                      .labelMedium!
                                      .copyWith(color: secondary),
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    routine.name,
                                    maxLines: 1,
                                    style: textTheme(context)
                                        .bodyLarge!
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                              //ROUTINE TYPE
                              SizedBox(
                                width: size(context).width * .65,
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  _getRoutineTypeText(context, routine.type),
                                  maxLines: 1,
                                  style: textTheme(context)
                                      .bodySmall!
                                      .copyWith(color: Colors.grey.shade400),
                                ),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.blue : Colors.grey,
                          )
                        ],
                      ),
                      FittedBox(
                        child: getWeekDays(context, ref, routine),
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget getWeekDays(
      BuildContext context, WidgetRef ref, RoutineModel routine) {
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
                color: routine.days[index]
                    ? Color(routine.colorValue).withAlpha(120)
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
