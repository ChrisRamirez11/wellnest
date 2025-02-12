// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/data_backup_restore/business/repositories/data_repository.dart';
import 'package:wellnest/feature/data_backup_restore/data/datasources/data_remote_datasource.dart';
import 'package:wellnest/feature/data_backup_restore/data/models/data_model.dart';

class DataRepositoryImpl implements DataRepository {
  final DataRemoteDatasource dataRemoteDatasource;

  DataRepositoryImpl({
    required this.dataRemoteDatasource,
  });

  @override
  Future<Either<Failure, DataModel>> getData() async {
    try {
      final res = await dataRemoteDatasource.getData();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateData(DataModel dataModel) async {
    try {
      await dataRemoteDatasource.updateData(dataModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
