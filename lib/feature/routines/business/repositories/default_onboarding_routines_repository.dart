import 'package:wellnest/feature/routines/data/models/routine_category.dart';

abstract class DefaultOnboardingRoutinesRepository {
  Future<List<RoutineCategory>> loadRoutines();
}