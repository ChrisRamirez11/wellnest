import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/entity/date_entity.dart';
import 'package:task_nest/feature/dates/business/repositories/date_repository.dart';

class GetDate {
  final DateRepository _dateRepository;

  GetDate(this._dateRepository);

  Future<Either<Failure, DateEntity?>> call(DateTime date) async {
    DateTime d = DateTime(date.year, date.month, date.day);
    return await _dateRepository.getDate(d);
  }
}
