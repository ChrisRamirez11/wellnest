import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/dates/business/usecases/get_date.dart';
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
  DateModel? _date;
  Failure? _failure;

  DateProvider() {
    getDates();
  }

  final DateRepositoryImpl repositoryImpl =
      DateRepositoryImpl(dateLocalDatasource: DateLocalDatasourceImpl());

  DateModel? get date => _date;
  List<DateModel>? get dates => _dates;
  Failure? get failure => _failure;

  setDateToNull() {
    _date = null;
    notifyListeners();
  }

  getDate(DateTime date, DateTime currentSelectedDate) async {
    //puede ser que a lo mejor lo primero que se haga sea adicionarlo a _dates y ya luego se mira si hace falta o no ponerlo en la BD
    final failureOrDate = await GetDate(repositoryImpl).call(date);
    failureOrDate.fold(
      (l) => _failure = l,
      (dateEntity) async {
        if (dateEntity != null) {
          _date = DateModel.fromEntity(dateEntity);
        } else {
          if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day)) ||
              date.isAtSameMomentAs(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))) {
            await upsertDate(DateModel(
                date: DateTime(currentSelectedDate.year,
                    currentSelectedDate.month, currentSelectedDate.day),
                routinesId: [],
                completedRoutineAmount: 0));
          } else {
            _date = DateModel(
                date: date, routinesId: [], completedRoutineAmount: 0);
            _dates!.add(_date!);
          }
        }
      },
    );
    notifyListeners();
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
        _date = dateModel;
        _dates!.add(dateModel);
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
