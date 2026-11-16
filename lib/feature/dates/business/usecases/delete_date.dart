import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/repositories/date_repository.dart';

class DeleteDate {
  final DateRepository _dateRepository;

  DeleteDate(this._dateRepository);

  Future<Either<Failure, void>> call(int id) async {
    return await _dateRepository.deleteDate(id);
  }
}
