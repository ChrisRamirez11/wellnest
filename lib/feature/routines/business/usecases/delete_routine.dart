import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/repositories/routine_repository.dart';

class DeleteRoutine {
  final RoutineRepository _routineRepository;

  DeleteRoutine(this._routineRepository);

  Future<Either<Failure, void>> call(int id) async {
    return await _routineRepository.deleteRoutine(id);
  }
}
