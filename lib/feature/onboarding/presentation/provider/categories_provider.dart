import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/feature/routines/data/datasources/local/default_onboarding_routines.dart';
import 'package:task_nest/feature/calendar/data/models/routine_category.dart';
import 'package:task_nest/feature/routines/data/repositories/default_onboarding_routines_repository_impl.dart';

final routineRepositoryProvider =
    Provider<DefaultOnboardingRoutinesRepositoryImpl>((ref) {
  return DefaultOnboardingRoutinesRepositoryImpl(DefaultOnboardingRoutines());
});

final categoriesProvider =
    StateProvider<DefaultOnboardingRoutinesRepositoryImpl>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  return repository;
});

final selectedCategoryProvider = StateProvider<RoutineCategory?>((ref) => null);

final selectedRoutinesProvider = StateProvider<List<String?>>((ref) => []);
