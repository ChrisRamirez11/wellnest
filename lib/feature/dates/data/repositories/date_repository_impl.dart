// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/dates/business/entity/date_entity.dart';
import 'package:task_nest/feature/dates/business/repositories/date_repository.dart';
import 'package:task_nest/feature/dates/data/datasources/local/date_local_datasource.dart';
import 'package:task_nest/feature/dates/data/models/date_model.dart';

class DateRepositoryImpl implements DateRepository {
  DateLocalDatasource dateLocalDatasource;

  DateRepositoryImpl({
    required this.dateLocalDatasource,
  });

  @override
  Future<Either<Failure, void>> deleteDate(int id) async {
    try {
      await dateLocalDatasource.deleteDate(id);
      return const Right(null);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, DateEntity?>> getDate(DateTime date) async {
    try {
      final dateModel = await dateLocalDatasource.getDate(date);
      return Right(dateModel?.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<DateEntity>>> getEveryDate() async {
    try {
      final dateModels = await dateLocalDatasource.getEveryDate();
      final res = dateModels.map((e) => e.toEntity()).toList();
      return Right(res);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, int>> upsertDate(DateEntity dateEntity) async {
    try {
      final res = await dateLocalDatasource
          .upsertDate(DateModel.fromEntity(dateEntity));
      return Right(res);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<int>>> upsertAllDates(
      List<DateEntity> dateEntities) async {
    try {
      final res = await dateLocalDatasource.upsertAllDates(dateEntities
          .map(
            (e) => DateModel.fromEntity(e),
          )
          .toList());
      return Right(res);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }
}
