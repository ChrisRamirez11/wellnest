import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/entity/date_entity.dart';
import 'package:task_nest/feature/dates/business/repositories/date_repository.dart';

class UpsertAllDates {
  final DateRepository _dateRepository;

  UpsertAllDates(this._dateRepository);

  Future<Either<Failure, List<int>>> call(List<DateEntity> dateEntities) async {
    return await _dateRepository.upsertAllDates(dateEntities);
  }
}
