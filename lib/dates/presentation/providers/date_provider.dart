import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/dates/business/usecases/get_every_date.dart';
import 'package:wellnest/dates/business/usecases/upsert_date.dart';
import 'package:wellnest/dates/data/datasources/local/date_local_datasource.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/data/repositories/date_repository_impl.dart';

final dateProvider = ChangeNotifierProvider(
  (ref) => DateProvider(),
);

class DateProvider extends ChangeNotifier {
  List<DateModel>? _dates;
  Failure? _failure;
  int currentIndex = 0;

  DateProvider() {
    getDates();
  }

  final DateRepositoryImpl repositoryImpl =
      DateRepositoryImpl(dateLocalDatasource: DateLocalDatasourceImpl());

  List<DateModel>? get dates => _dates;
  Failure? get failure => _failure;


  Future<void> changeDate(DateTime d) async {
    d = DateTime(d.year, d.month, d.day);
    
    //We check if d exists and in case true we set currentIndex to the date index
    for (final dateModel in _dates!) {
      if (dateModel.date.isAtSameMomentAs(d)) {
        currentIndex = _dates!.indexOf(dateModel);
        notifyListeners();
        return;
      }
    }
    //if d is not in the list then we insert it
    _dates!.insert(
        0, DateModel(date: d, routinesId: [], completedRoutineAmount: 0));
    currentIndex = 0;
    notifyListeners();
    return;
  }

  upsertDate(DateModel dateModel) async {
    final res = await UpsertDate(repositoryImpl).call(dateModel.toEntity());

    if (_dates!.contains(dateModel)) {
      final routineIndex = _dates!.indexOf(dateModel);

      res.fold((l) => log('error upserting ${l.errorMessage}'), (r) {
        _dates!.removeAt(routineIndex);
        _dates!.insert(routineIndex, dateModel);
      });
    } else {
      res.fold((l) => _failure = failure, (id) {
        dateModel.id = id;
        _dates!.insert(0, dateModel);
        currentIndex = 0;
      });
    }
    notifyListeners();
  }

  getDates() async {
    final res = await GetEveryDate(repositoryImpl).call();
    res.fold(
      (l) => log('error loading the dates ${l.errorMessage}'),
      (dateEntities) =>
          _dates = dateEntities.map((e) => DateModel.fromEntity(e)).toList(),
    );
    notifyListeners();
  }
}
