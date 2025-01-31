import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/dates/business/entity/date_entity.dart';
import 'package:wellnest/dates/business/repositories/date_repository.dart';

class GetDate {
  final DateRepository _dateRepository;

  GetDate(this._dateRepository);

  Future<Either<Failure, DateEntity?>> call(DateTime date) async {
    DateTime d = DateTime(date.year, date.month, date.day);
    return await _dateRepository.getDate(d);
  }
}