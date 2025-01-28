import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/routines/business/entity/routine_entity.dart';
import 'package:wellnest/routines/business/repositories/routine_repository.dart';

class GetRoutine {
  final RoutineRepository _routineRepository;

  GetRoutine(this._routineRepository);

  Future<Either<Failure, RoutineEntity>> call(int id) async {
    return await _routineRepository.getRoutine(id);
  }
}