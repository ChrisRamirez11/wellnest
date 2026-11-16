import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/entity/date_entity.dart';

abstract class DateRepository {
  Future<Either<Failure, int>> upsertDate(DateEntity dateEntity);
  Future<Either<Failure, List<int>>> upsertAllDates(
      List<DateEntity> dateEntities);
  Future<Either<Failure, DateEntity?>> getDate(DateTime date);
  Future<Either<Failure, List<DateEntity>>> getEveryDate();
  Future<Either<Failure, void>> deleteDate(int id);
}
