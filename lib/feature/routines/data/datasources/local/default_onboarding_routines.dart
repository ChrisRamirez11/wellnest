import 'package:flutter/widgets.dart';
import 'package:task_nest/feature/calendar/data/models/routine_category.dart';
import 'package:task_nest/feature/routines/data/datasources/local/routine_category_list.dart';

class DefaultOnboardingRoutines {
  List<RoutineCategory> loadRoutines(BuildContext context) {
    return routineCategories(context);
  }
}
