import 'package:wellnest/feature/routines/business/repositories/default_onboarding_routines_repository.dart';
import 'package:wellnest/feature/routines/data/datasources/local/default_onboarding_routines.dart';
import 'package:wellnest/feature/routines/data/models/routine_category.dart';

class DefaultOnboardingRoutinesRepositoryImpl extends DefaultOnboardingRoutinesRepository {
  final DefaultOnboardingRoutines _defaultOnboardingRoutines;

  DefaultOnboardingRoutinesRepositoryImpl(this._defaultOnboardingRoutines);

  @override
  Future<List<RoutineCategory>> loadRoutines() async {
    return await _defaultOnboardingRoutines.loadRoutines();
  }
  
}