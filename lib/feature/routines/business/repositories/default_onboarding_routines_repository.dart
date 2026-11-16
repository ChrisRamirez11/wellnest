import 'package:flutter/material.dart';
import 'package:task_nest/feature/calendar/data/models/routine_category.dart';

abstract class DefaultOnboardingRoutinesRepository {
  List<RoutineCategory> loadRoutines(BuildContext context);
}
