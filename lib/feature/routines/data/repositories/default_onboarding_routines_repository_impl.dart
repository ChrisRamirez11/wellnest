import 'package:flutter/material.dart';
import 'package:task_nest/feature/routines/business/repositories/default_onboarding_routines_repository.dart';
import 'package:task_nest/feature/routines/data/datasources/local/default_onboarding_routines.dart';
import 'package:task_nest/feature/calendar/data/models/routine_category.dart';

class DefaultOnboardingRoutinesRepositoryImpl
    extends DefaultOnboardingRoutinesRepository {
  final DefaultOnboardingRoutines _defaultOnboardingRoutines;

  DefaultOnboardingRoutinesRepositoryImpl(this._defaultOnboardingRoutines);

  @override
  List<RoutineCategory> loadRoutines(BuildContext context) {
    return _defaultOnboardingRoutines.loadRoutines(context);
  }
}
