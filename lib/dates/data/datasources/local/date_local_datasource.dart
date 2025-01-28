import 'package:isar/isar.dart';
import 'package:wellnest/core/utils/isar_database.dart';
import 'package:wellnest/errors/excpetions.dart';
import 'package:wellnest/dates/data/models/date_model.dart';

abstract class DateLocalDatasource {
  Future<DateModel?> getDate(int id);
  Future<List<DateModel>> getEveryDate();
  Future<int> upsertDate(DateModel dateModel);
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
  Future<DateModel?> getDate(int id) async {
    try {
      final isarInstance = await IsarDatabase().isar;
      return await isarInstance.dateModels.get(id);
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
    try {
      int? res;
      final isarInstance = await IsarDatabase().isar;
      isarInstance.writeTxn(
          () async => res = await isarInstance.dateModels.put(dateModel));
      return res!;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
