// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/feature/routines/business/usecases/delete_routine.dart';
import 'package:task_nest/feature/routines/business/usecases/get_every_routine.dart';
import 'package:task_nest/feature/routines/business/usecases/seed_from_api.dart';
import 'package:task_nest/feature/routines/business/usecases/upsert_all_routines.dart';
import 'package:task_nest/feature/routines/business/usecases/upsert_routine.dart';
import 'package:task_nest/feature/routines/data/datasources/local/routine_local_datasource.dart';
import 'package:task_nest/feature/routines/data/models/routine_model.dart';
import 'package:task_nest/feature/routines/data/repositories/routine_repository_impl.dart';

final routineProvider = ChangeNotifierProvider(
  (ref) => RoutineProvider(),
);

class RoutineProvider extends ChangeNotifier {
  List<RoutineModel>? _routines;
  Failure? _failure;
  String? _apiSeedError;

  RoutineProvider() {
    getRoutines();
  }

  final RoutineRepositoryImpl repositoryImpl = RoutineRepositoryImpl(
      routineLocalDatasource: RoutineLocalDatasourceImpl());

  List<RoutineModel>? get routines => _routines;
  Failure? get failure => _failure;

  /// User-facing message of the last failed API seed, if any.
  String? get apiSeedError => _apiSeedError;

  void clearApiSeedError() {
    _apiSeedError = null;
    notifyListeners();
  }

  Future<void> seedFromApi() async {
    final failureOrRoutines = await SeedFromApi(repositoryImpl).call();

    final failure = failureOrRoutines.fold<Failure?>((l) => l, (_) => null);
    _apiSeedError = failure?.errorMessage;
    notifyListeners();

    if (failure == null) {
      await getRoutines();
    }
  }

  Future<void> getRoutines() async {
    final failureOrRoutine = await GetEveryRoutine(repositoryImpl).call();

    failureOrRoutine.fold(
      (l) => _failure = failure,
      (r) => _routines = r
          .map(
            (e) => RoutineModel.fromEntity(e),
          )
          .toList(),
    );
    notifyListeners();
  }

  Future<void> deleteRoutine(int id) async {
    final failureOrVoid = await DeleteRoutine(repositoryImpl).call(id);

    failureOrVoid.fold(
        (l) => log('failure'),
        (r) => _routines!.removeWhere(
              (element) => element.id == id,
            ));
    notifyListeners();
  }

  Future<void> upsertRoutine(RoutineModel routineModel) async {
    final failureOrRoutine =
        await UpsertRoutine(repositoryImpl).call(routineModel.toEntity());

    if (_routines!.any(
      (element) => element.id == routineModel.id,
    )) {
      final routineIndex = _routines!.indexWhere(
        (element) => element.id == routineModel.id,
      );

      failureOrRoutine.fold((l) => _failure = failure, (r) {
        _routines!.removeAt(routineIndex);
        _routines!.insert(routineIndex, routineModel);
      });
    } else {
      failureOrRoutine.fold((l) => _failure = failure, (r) {
        routineModel.id = r;
        _routines!.add(routineModel);
      });
    }
    notifyListeners();
  }

  Future<void> upsertAllRoutines(List<RoutineModel> routines) async {
    final failureOrRoutine =
        await UpsertAllRoutines(repositoryImpl).call(routines
            .map(
              (e) => e.toEntity(),
            )
            .toList());

    for (int i = 0; i < routines.length; i++) {
      if (_routines!.any(
        (element) => element.id == routines[i].id,
      )) {
        final routineIndex = _routines!.indexWhere(
          (element) => element.id == routines[i].id,
        );

        failureOrRoutine.fold((l) => _failure = failure, (r) {
          _routines!.removeAt(routineIndex);
          _routines!.insert(routineIndex, routines[i]);
        });
      } else {
        failureOrRoutine.fold((l) => _failure = failure, (r) {
          routines[i].id = routines[i].id;
          _routines!.add(routines[i]);
        });
      }
    }
    notifyListeners();
  }
}
