// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:task_nest/core/errors/excpetions.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/business/repositories/routine_repository.dart';
import 'package:task_nest/feature/routines/data/datasources/local/routine_local_datasource.dart';
import 'package:task_nest/feature/routines/data/datasources/remote/routine_remote_datasource.dart';
import 'package:task_nest/feature/routines/data/models/routine_model.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDatasource routineLocalDatasource;
  final RoutineRemoteDatasource routineRemoteDatasource;

  RoutineRepositoryImpl({
    required this.routineLocalDatasource,
    RoutineRemoteDatasource? routineRemoteDatasource,
  }) : routineRemoteDatasource =
            routineRemoteDatasource ?? RoutineRemoteDatasourceImpl();

  @override
  Future<Either<Failure, void>> deleteRoutine(int id) async {
    try {
      await routineLocalDatasource.deleteRoutine(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RoutineEntity>>> getEveryRoutine() async {
    try {
      final routineModels = await routineLocalDatasource.getEveryRoutine();

      final res = routineModels.map((e) => e.toEntity()).toList();

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
      final d = DateTime(routine.createdDate.year, routine.createdDate.month,
          routine.createdDate.day);
      routine.createdDate = d;
      final res = await routineLocalDatasource
          .upsertRoutine(RoutineModel.fromEntity(routine));
      return Right(res);
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, List<int>>> upsertAllRoutines(
      List<RoutineEntity> routines) async {
    try {
      final res = await routineLocalDatasource.upsertAllRoutines(routines
          .map(
            (e) => RoutineModel.fromEntity(e),
          )
          .toList());
      return Right(res);
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RoutineEntity>>> seedFromApi() async {
    try {
      final remoteRoutines = await routineRemoteDatasource.fetchTodos();

      if (remoteRoutines.isEmpty) {
        return const Right(<RoutineEntity>[]);
      }

      await routineLocalDatasource.upsertAllRoutines(
        remoteRoutines.map(RoutineModel.fromEntity).toList(),
      );

      return Right(remoteRoutines);
    } on ServerException catch (e) {
      return Left(NetworkFailure(errorMessage: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    }
  }
}
