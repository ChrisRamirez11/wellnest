import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/business/repositories/routine_repository.dart';

class UpsertAllRoutines {
  final RoutineRepository _routineRepository;

  UpsertAllRoutines(this._routineRepository);

  Future<Either<Failure, List<int>>> call(
      List<RoutineEntity> routineEntities) async {
    return await _routineRepository.upsertAllRoutines(routineEntities);
  }
}
