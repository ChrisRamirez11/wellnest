import 'package:isar/isar.dart';
import 'package:wellnest/core/local_dbs/isar_database.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';

abstract class RoutineLocalDatasource {
  Future<RoutineModel?> getRoutine(int id);
  Future<List<RoutineModel>> getEveryRoutine();
  Future<int> upsertRoutine(RoutineModel routineModel);
  Future<void> upsertAllRoutines(List<RoutineModel> routineModels);
  Future<void> deleteRoutine(int id);
}

class RoutineLocalDatasourceImpl implements RoutineLocalDatasource {
  @override
  Future<int> upsertRoutine(RoutineModel routineModel) async {
    int? res;
    try {
      final isarInstance = await IsarDatabase().isar;
      await isarInstance.writeTxn(
        () async => res = await isarInstance.routineModels.put(routineModel),
      );
      return res!;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<RoutineModel?> getRoutine(int id) async {
    try {
      final isarInstance = await  IsarDatabase().isar;
      return await isarInstance.routineModels.get(id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<RoutineModel>> getEveryRoutine() async {
    try {
      final isarInstance = await  IsarDatabase().isar;
      return await isarInstance.routineModels.where().findAll();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> deleteRoutine(int id) async {
    try{
      final isarInstance = await  IsarDatabase().isar;
      await isarInstance.writeTxn(
        () async => await isarInstance.routineModels.delete(id),
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
  
  @override
  Future<void> upsertAllRoutines(List<RoutineModel> routineModels) async {
    try{
      final isarInstance = await  IsarDatabase().isar;
      await isarInstance.writeTxn(
        () async => await isarInstance.routineModels.putAll(routineModels),
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
