import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/business/repositories/routine_repository.dart';

/// In-memory repository used by unit and widget tests.
class FakeRoutineRepository implements RoutineRepository {
  FakeRoutineRepository({
    this.seedResult = const Right(<RoutineEntity>[]),
    this.everyRoutineResult = const Right(<RoutineEntity>[]),
  });

  Either<Failure, List<RoutineEntity>> seedResult;
  Either<Failure, List<RoutineEntity>> everyRoutineResult;

  int seedCalls = 0;
  List<RoutineEntity>? lastPersistedRoutines;

  @override
  Future<Either<Failure, List<RoutineEntity>>> seedFromApi() async {
    seedCalls++;
    return seedResult;
  }

  @override
  Future<Either<Failure, List<RoutineEntity>>> getEveryRoutine() async {
    return everyRoutineResult;
  }

  @override
  Future<Either<Failure, int>> upsertRoutine(RoutineEntity routine) async {
    return const Right(0);
  }

  @override
  Future<Either<Failure, List<int>>> upsertAllRoutines(
    List<RoutineEntity> routines,
  ) async {
    lastPersistedRoutines = routines;
    return Right(List<int>.generate(routines.length, (index) => index));
  }

  @override
  Future<Either<Failure, RoutineEntity>> getRoutine(int id) async {
    return Left(CacheFailure(errorMessage: 'Routine $id not found'));
  }

  @override
  Future<Either<Failure, void>> deleteRoutine(int id) async {
    return const Right(null);
  }
}
