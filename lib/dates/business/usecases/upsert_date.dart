import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/dates/business/entity/date_entity.dart';
import 'package:wellnest/dates/business/repositories/date_repository.dart';

class UpsertDate {
  final DateRepository _dateRepository;

  UpsertDate(this._dateRepository);

  Future<Either<Failure, int>> call(DateEntity dateEntity) async {
    return await _dateRepository.upsertDate(dateEntity);
  }
}