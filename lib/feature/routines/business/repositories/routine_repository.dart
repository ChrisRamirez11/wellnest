import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';

abstract class RoutineRepository {
  Future<Either<Failure, int>> upsertRoutine(RoutineEntity routine);
  Future<Either<Failure, List<int>>> upsertAllRoutines(
      List<RoutineEntity> routines);
  Future<Either<Failure, RoutineEntity>> getRoutine(int id);
  Future<Either<Failure, List<RoutineEntity>>> getEveryRoutine();
  Future<Either<Failure, void>> deleteRoutine(int id);
}
