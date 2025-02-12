// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/data_backup_restore/business/repositories/data_repository.dart';
import 'package:wellnest/feature/data_backup_restore/data/models/data_model.dart';

class UpdateDataUsecase {
  final DataRepository dataRepository;
  UpdateDataUsecase({
    required this.dataRepository,
  });

  Future<Either<Failure, void>> call(DataModel dataModel) async {
    return await dataRepository.updateData(dataModel);
  }
}
