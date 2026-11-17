import 'package:flutter_test/flutter_test.dart';
import 'package:task_nest/core/errors/excpetions.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/data/datasources/local/routine_local_datasource.dart';
import 'package:task_nest/feature/routines/data/datasources/remote/routine_remote_datasource.dart';
import 'package:task_nest/feature/routines/data/models/routine_model.dart';
import 'package:task_nest/feature/routines/data/repositories/routine_repository_impl.dart';

RoutineEntity _routine(String name) {
  final now = DateTime.now();
  return RoutineEntity(
    name: name,
    days: const [true, true, true, true, true, true, true],
    finished: false,
    createdDate: DateTime(now.year, now.month, now.day),
    colorValue: 0xFF2196F3,
    type: 'task',
    targetCount: 1,
    currentCount: 0,
    targetDuration: 0,
    elapsedTime: 0,
  );
}

class _FakeRemoteDatasource implements RoutineRemoteDatasource {
  _FakeRemoteDatasource(this._handler);

  final Future<List<RoutineEntity>> Function() _handler;

  @override
  Future<List<RoutineEntity>> fetchTodos() => _handler();
}

class _FakeLocalDatasource implements RoutineLocalDatasource {
  _FakeLocalDatasource({this.upsertError});

  List<RoutineModel>? persisted;
  Object? upsertError;

  @override
  Future<RoutineModel?> getRoutine(int id) async => null;

  @override
  Future<List<RoutineModel>> getEveryRoutine() async => persisted ?? [];

  @override
  Future<int> upsertRoutine(RoutineModel routineModel) async => 0;

  @override
  Future<List<int>> upsertAllRoutines(
    List<RoutineModel> routineModels,
  ) async {
    final error = upsertError;
    if (error != null) throw error;
    persisted = routineModels;
    return List<int>.generate(routineModels.length, (index) => index + 1);
  }

  @override
  Future<void> deleteRoutine(int id) async {}
}

void main() {
  group('RoutineRepositoryImpl.seedFromApi', () {
    test('stores the imported routines locally and returns them', () async {
      final localDatasource = _FakeLocalDatasource();
      final remoteDatasource = _FakeRemoteDatasource(
        () async => [_routine('Remote task')],
      );
      final repository = RoutineRepositoryImpl(
        routineLocalDatasource: localDatasource,
        routineRemoteDatasource: remoteDatasource,
      );

      final result = await repository.seedFromApi();

      final imported = result.getOrElse(() => <RoutineEntity>[]);
      expect(imported, hasLength(1));
      expect(imported.single.name, 'Remote task');
      expect(localDatasource.persisted, hasLength(1));
      expect(localDatasource.persisted!.single.name, 'Remote task');
    });

    test('maps remote exceptions to NetworkFailure', () async {
      final repository = RoutineRepositoryImpl(
        routineLocalDatasource: _FakeLocalDatasource(),
        routineRemoteDatasource: _FakeRemoteDatasource(
          () async => throw ServerException(message: 'no connection'),
        ),
      );

      final result = await repository.seedFromApi();

      final failure = result.fold<Failure?>((l) => l, (_) => null);
      expect(failure, isA<NetworkFailure>());
      expect(failure!.errorMessage, 'no connection');
    });

    test('maps local write exceptions to CacheFailure', () async {
      final repository = RoutineRepositoryImpl(
        routineLocalDatasource: _FakeLocalDatasource(
          upsertError: CacheException(message: 'db is locked'),
        ),
        routineRemoteDatasource: _FakeRemoteDatasource(
          () async => [_routine('Remote task')],
        ),
      );

      final result = await repository.seedFromApi();

      final failure = result.fold<Failure?>((l) => l, (_) => null);
      expect(failure, isA<CacheFailure>());
      expect(failure!.errorMessage, 'db is locked');
    });
  });
}
