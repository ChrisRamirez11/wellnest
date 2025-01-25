import 'package:dartz/dartz.dart';
import 'package:wellnest/errors/failures.dart';
import 'package:wellnest/routines/business/repositories/routine_repository.dart';

class DeleteRoutine {
  final RoutineRepository _routineRepository;

  DeleteRoutine(this._routineRepository);

  Future<Either<Failure, void>> call(int id) async {
    return await _routineRepository.deleteRoutine(id);
  }
}