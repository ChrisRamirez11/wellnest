import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';
import 'package:wellnest/feature/routines/business/repositories/routine_repository.dart';

class UpsertAllRoutines {
  final RoutineRepository _routineRepository;

  UpsertAllRoutines(this._routineRepository);

  Future<Either<Failure, void>> call(List<RoutineEntity> routineEntities) async {
    return await _routineRepository.upsertAllRoutines(routineEntities);
  }
}