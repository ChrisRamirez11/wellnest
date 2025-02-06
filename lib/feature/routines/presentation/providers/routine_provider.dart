// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/routines/business/usecases/delete_routine.dart';
import 'package:wellnest/feature/routines/business/usecases/get_every_routine.dart';
import 'package:wellnest/feature/routines/business/usecases/upsert_routine.dart';
import 'package:wellnest/feature/routines/data/datasources/local/routine_local_datasource.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/routines/data/repositories/routine_repository_impl.dart';

final routineProvider = ChangeNotifierProvider(
  (ref) => RoutineProvider(),
);

class RoutineProvider extends ChangeNotifier {
  List<RoutineModel>? _routines;
  Failure? _failure;

  RoutineProvider() {
    getRoutines();
  }

  final RoutineRepositoryImpl repositoryImpl = RoutineRepositoryImpl(
      routineLocalDatasource: RoutineLocalDatasourceImpl());

  List<RoutineModel>? get routines => _routines;
  Failure? get failure => _failure;

  getRoutines() async {
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

  deleteRoutine(int id) async {
    final failureOrVoid = await DeleteRoutine(repositoryImpl).call(id);

    failureOrVoid.fold(
        (l) => log('failure'),
        (r) => _routines!.removeWhere(
              (element) => element.id == id,
            ));
    notifyListeners();
  }

  upsertRoutine(RoutineModel routineModel) async {
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
}
