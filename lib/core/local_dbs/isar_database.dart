import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_nest/feature/dates/data/models/date_model.dart';
import 'package:task_nest/feature/routines/data/models/routine_model.dart';

class IsarDatabase {
  IsarDatabase._privateConstructor();

  static final IsarDatabase _instance = IsarDatabase._privateConstructor();

  factory IsarDatabase() {
    return _instance;
  }

  Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open([RoutineModelSchema, DateModelSchema],
        directory: dir.path);
    return _isar!;
  }
}
