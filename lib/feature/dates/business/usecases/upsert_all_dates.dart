import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/dates/business/entity/date_entity.dart';
import 'package:wellnest/feature/dates/business/repositories/date_repository.dart';

class UpsertAllDates {
  final DateRepository _dateRepository;

  UpsertAllDates(this._dateRepository);

  Future<Either<Failure, List<int>>> call(List<DateEntity> dateEntities) async {
    return await _dateRepository.upsertAllDates(dateEntities);
  }
}
