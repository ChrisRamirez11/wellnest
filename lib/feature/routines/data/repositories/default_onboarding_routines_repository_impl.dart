import 'package:flutter/material.dart';
import 'package:wellnest/feature/routines/business/repositories/default_onboarding_routines_repository.dart';
import 'package:wellnest/feature/routines/data/datasources/local/default_onboarding_routines.dart';
import 'package:wellnest/feature/calendar/data/models/routine_category.dart';

class DefaultOnboardingRoutinesRepositoryImpl extends DefaultOnboardingRoutinesRepository {
  final DefaultOnboardingRoutines _defaultOnboardingRoutines;

  DefaultOnboardingRoutinesRepositoryImpl(this._defaultOnboardingRoutines);

  @override
  List<RoutineCategory> loadRoutines(BuildContext context) {
    return _defaultOnboardingRoutines.loadRoutines(context);
  }
  
}