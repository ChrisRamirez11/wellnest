import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/business/repositories/routine_repository.dart';

class GetRoutine {
  final RoutineRepository _routineRepository;

  GetRoutine(this._routineRepository);

  Future<Either<Failure, RoutineEntity>> call(int id) async {
    return await _routineRepository.getRoutine(id);
  }
}
