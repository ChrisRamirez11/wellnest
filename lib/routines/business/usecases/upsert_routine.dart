import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/routines/business/entity/routine_entity.dart';
import 'package:wellnest/routines/business/repositories/routine_repository.dart';

class UpsertRoutine {
  final RoutineRepository _routineRepository;

  UpsertRoutine(this._routineRepository);

  Future<Either<Failure, int>> call(RoutineEntity routineEntity) async {
    return await _routineRepository.upsertRoutine(routineEntity);
  }
}