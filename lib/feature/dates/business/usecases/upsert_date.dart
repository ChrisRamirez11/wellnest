import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/entity/date_entity.dart';
import 'package:task_nest/feature/dates/business/repositories/date_repository.dart';

class UpsertDate {
  final DateRepository _dateRepository;

  UpsertDate(this._dateRepository);

  Future<Either<Failure, int>> call(DateEntity dateEntity) async {
    return await _dateRepository.upsertDate(dateEntity);
  }
}
