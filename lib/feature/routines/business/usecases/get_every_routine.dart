import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/business/repositories/routine_repository.dart';

class GetEveryRoutine {
  final RoutineRepository _routineRepository;

  GetEveryRoutine(this._routineRepository);

  Future<Either<Failure, List<RoutineEntity>>> call() async {
    return await _routineRepository.getEveryRoutine();
  }
}
