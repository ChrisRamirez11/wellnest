import 'package:wellnest/feature/calendar/data/models/routine_category.dart';

abstract class DefaultOnboardingRoutinesRepository {
  Future<List<RoutineCategory>> loadRoutines();
}