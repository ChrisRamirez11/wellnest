// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/data_backup_restore/business/entity/data_entity.dart';
import 'package:wellnest/feature/data_backup_restore/business/repositories/data_repository.dart';

class GetDataUsecase {
  final DataRepository dataRepository;

  GetDataUsecase({
    required this.dataRepository,
  });

  Future<Either<Failure, DataEntity>> call() async {
    return await dataRepository.getData();
  }
}
