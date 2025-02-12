import 'package:dartz/dartz.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/data_backup_restore/data/models/data_model.dart';

abstract class DataRepository {
  Future<Either<Failure, DataModel>> getData();
  Future<Either<Failure, void>> updateData(DataModel dataModel);
}