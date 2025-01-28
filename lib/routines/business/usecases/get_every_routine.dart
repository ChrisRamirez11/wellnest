import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/routines/business/entity/routine_entity.dart';
import 'package:wellnest/routines/business/repositories/routine_repository.dart';

class GetEveryRoutine {
  final RoutineRepository _routineRepository;

  GetEveryRoutine(this._routineRepository);

  Future<Either<Failure, List<RoutineEntity>>> call() async {
    return await _routineRepository.getEveryRoutine();
  }
}