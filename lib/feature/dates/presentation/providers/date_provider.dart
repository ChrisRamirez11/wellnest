import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/feature/dates/business/usecases/delete_date.dart';
import 'package:wellnest/feature/dates/business/usecases/get_every_date.dart';
import 'package:wellnest/feature/dates/business/usecases/upsert_all_dates.dart';
import 'package:wellnest/feature/dates/business/usecases/upsert_date.dart';
import 'package:wellnest/feature/dates/data/datasources/local/date_local_datasource.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/data/repositories/date_repository_impl.dart';

final dateProvider = ChangeNotifierProvider(
  (ref) => DateProvider(),
);

class DateProvider extends ChangeNotifier {
  List<DateModel>? _dates;
  Failure? _failure;
  DateModel? _date;

  DateProvider() {
    getDates();
  }

  final DateRepositoryImpl repositoryImpl =
      DateRepositoryImpl(dateLocalDatasource: DateLocalDatasourceImpl());

  List<DateModel>? get dates => _dates;
  DateModel? get date => _date;
  Failure? get failure => _failure;

  void setDate(DateModel d) {
    _date = d;
    notifyListeners();
  }

  Future<void> upsertDate(DateModel dateModel) async {
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
      });
    }
    _date = dateModel;
    notifyListeners();
  }

  Future<void> getDates() async {
    final res = await GetEveryDate(repositoryImpl).call();
    res.fold(
      (l) => log('error loading the dates ${l.errorMessage}'),
      (dateEntities) =>
          _dates = dateEntities.map((e) => DateModel.fromEntity(e)).toList(),
    );
    notifyListeners();
  }

  Future<void> deleteDate(int id) async {
    final res = await DeleteDate(repositoryImpl).call(id);
    res.fold(
      (l) => log('error deleting the date ${l.errorMessage}'),
      (r) => debugPrint('date succesfully deleted'),
    );

    _dates!.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  Future<void> upsertAllDates(List<DateModel> list) async {
    final res = await UpsertAllDates(repositoryImpl).call(list
        .map(
          (e) => e.toEntity(),
        )
        .toList());

    for (int i = 0; i < list.length; i++) {
      if (_dates!.contains(list[i])) {
        final dateIndex = _dates!.indexOf(list[i]);

        res.fold((l) => log('error upserting ${l.errorMessage}'), (r) {
          _dates!.removeAt(dateIndex);
          _dates!.insert(dateIndex, list[i]);
        });
      } else {
        res.fold((l) => _failure = failure, (id) {
          list[i].id = list[i].id;
          _dates!.insert(0, list[i]);
        });
      }
    }
    notifyListeners();
  }
}
