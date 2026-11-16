import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/entity/date_entity.dart';
import 'package:task_nest/feature/dates/business/repositories/date_repository.dart';

class GetEveryDate {
  final DateRepository _dateRepository;

  GetEveryDate(this._dateRepository);

  Future<Either<Failure, List<DateEntity>>> call() async {
    return await _dateRepository.getEveryDate();
  }
}
