import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/business/usecases/seed_from_api.dart';

import '../../../../helpers/fake_routine_repository.dart';

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

void main() {
  group('SeedFromApi', () {
    test('returns the routines imported by the repository', () async {
      final imported = [_routine('Imported task')];
      final repository = FakeRoutineRepository(seedResult: Right(imported));

      final result = await SeedFromApi(repository).call();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => <RoutineEntity>[]), imported);
      expect(repository.seedCalls, 1);
    });

    test('forwards network failures from the repository', () async {
      final repository = FakeRoutineRepository(
        seedResult: Left(NetworkFailure(errorMessage: 'offline')),
      );

      final result = await SeedFromApi(repository).call();

      final failure = result.fold<Failure?>((l) => l, (_) => null);
      expect(failure, isA<NetworkFailure>());
      expect(failure!.errorMessage, 'offline');
      expect(repository.seedCalls, 1);
    });
  });
}
