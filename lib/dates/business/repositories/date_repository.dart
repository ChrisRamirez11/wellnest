import 'package:dartz/dartz.dart';
import 'package:wellnest/errors/failures.dart';
import 'package:wellnest/dates/business/entity/date_entity.dart';

abstract class DateRepository {
  Future<Either<Failure, int>> upsertDate(DateEntity dateEntity);
  Future<Either<Failure, DateEntity>> getDate(int id);
  Future<Either<Failure, List<DateEntity>>> getEveryDate();
  Future<Either<Failure, void>> deleteDate(int id);
}
