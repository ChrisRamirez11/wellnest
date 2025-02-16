import 'package:isar/isar.dart';
import 'package:wellnest/core/local_dbs/isar_database.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';

abstract class DateLocalDatasource {
  Future<DateModel?> getDate(DateTime date);
  Future<List<DateModel>> getEveryDate();
  Future<int> upsertDate(DateModel dateModel);
  Future<List<int>> upsertAllDates(List<DateModel> dateModels);
  Future<void> deleteDate(int id);
}

class DateLocalDatasourceImpl implements DateLocalDatasource {
  @override
  Future<void> deleteDate(int id) async {
    try {
      final isarInsatnce = await IsarDatabase().isar;
      isarInsatnce
          .writeTxn(() async => await isarInsatnce.dateModels.delete(id));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<DateModel?> getDate(DateTime date) async {
    try {
      final isarInstance = await IsarDatabase().isar;
      return await isarInstance.dateModels
          .where()
          .filter()
          .dateEqualTo(date)
          .findFirst();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<DateModel>> getEveryDate() async {
    try {
      final isarInstance = await IsarDatabase().isar;
      return await isarInstance.dateModels.where().findAll();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<int> upsertDate(DateModel dateModel) async {
    final d =
        DateTime(dateModel.date.year, dateModel.date.month, dateModel.date.day);
    dateModel.date = d;
    try {
      int? res;
      final isarInstance = await IsarDatabase().isar;
      await isarInstance.writeTxn(
          () async => res = await isarInstance.dateModels.put(dateModel));
      return res!;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
  
  @override
  Future<List<int>> upsertAllDates(List<DateModel> dateModels) async {
    try {
      final isarInstance = await IsarDatabase().isar;
      final res = await isarInstance.writeTxn(
          () async => await isarInstance.dateModels.putAll(dateModels));
          return res;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
