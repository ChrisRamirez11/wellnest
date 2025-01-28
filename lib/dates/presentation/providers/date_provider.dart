import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/dates/business/usecases/get_every_date.dart';
import 'package:wellnest/dates/business/usecases/upsert_date.dart';
import 'package:wellnest/dates/business/usecases/delete_date.dart';
import 'package:wellnest/dates/data/datasources/local/date_local_datasource.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/data/repositories/date_repository_impl.dart';

final dateProvider = ChangeNotifierProvider(
  (ref) => DateProvider(),
);

class DateProvider extends ChangeNotifier {
  List<DateModel>? _dates;
  Failure? _failure;

  DateProvider() {
    getDates();
  }

  final DateRepositoryImpl repositoryImpl = DateRepositoryImpl(
      dateLocalDatasource: DateLocalDatasourceImpl());

  List<DateModel>? get dates => _dates;
  Failure? get failure => _failure;

  getDates() async {
    final failureOrDate = await GetEveryDate(repositoryImpl).call();

    failureOrDate.fold(
      (l) => _failure = l,
      (r) => _dates = r
          .map(
            (e) => DateModel.fromEntity(e),
          )
          .toList(),
    );
    notifyListeners();
  }

  deleteDate(int id) async {
    final failureOrVoid = await DeleteDate(repositoryImpl).call(id);

    failureOrVoid.fold(
        (l) => log('failure'),
        (r) => _dates!.removeWhere(
              (element) => element.id == id,
            ));
    notifyListeners();
  }

  upsertDate(DateModel dateModel) async {
    final failureOrDate =
        await UpsertDate(repositoryImpl).call(dateModel.toEntity());

    if (_dates!.contains(dateModel)) {
      final dateIndex = _dates!.indexOf(dateModel);

      failureOrDate.fold((l) => _failure = l, (r) {
        _dates!.removeAt(dateIndex);
        _dates!.insert(dateIndex, dateModel);
      });
    } else {
      failureOrDate.fold((l) => _failure = l, (r) {
        dateModel.id = r;
        _dates!.add(dateModel);
      });
    }
    notifyListeners();
  }
}