import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/dates/business/repositories/date_repository.dart';

class DeleteDate {
  final DateRepository _dateRepository;

  DeleteDate(this._dateRepository);

  Future<Either<Failure, void>> call(int id) async {
    return await _dateRepository.deleteDate(id);
  }
}
