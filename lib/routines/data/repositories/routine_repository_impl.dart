// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:wellnest/errors/excpetions.dart';
import 'package:wellnest/errors/failures.dart';
import 'package:wellnest/routines/business/entity/routine_entity.dart';
import 'package:wellnest/routines/business/repositories/routine_repository.dart';
import 'package:wellnest/routines/data/datasources/local/routine_local_datasource.dart';
import 'package:wellnest/routines/data/models/routine/routine_model.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  RoutineLocalDatasource routineLocalDatasource;

  RoutineRepositoryImpl({
    required this.routineLocalDatasource,
  });

  @override
  Future<Either<Failure, void>> deleteRoutine(int id) async {
    try {
      await routineLocalDatasource.deleteRoutine(id);
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RoutineEntity>>> getEveryRoutine() async {
    try {
      final routineModels = await routineLocalDatasource.getEveryRoutine();

      final res = routineModels
          .map((e) => RoutineEntity(
                id: e.id!,
                name: e.name,
                days: e.days,
                finished: e.finished,
                createdDate: e.createdDate
              ))
          .toList();

      return Right(res);
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, RoutineEntity>> getRoutine(int id) async {
    try {
      final routineModel = await routineLocalDatasource.getRoutine(id);
      return Right(routineModel!.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> upsertRoutine(RoutineEntity routine) async {
    try {
      final res = await routineLocalDatasource
          .upsertRoutine(RoutineModel.fromEntity(routine));
      return Right(res);
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }
}
