import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentSelectedDateProvider = ChangeNotifierProvider(
  (ref) => CurrentSelectedDateProvider(),
);

class CurrentSelectedDateProvider extends ChangeNotifier {
  var _currentSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get currentSelectedDate => _currentSelectedDate;

  void changeDate(DateTime date) {
    _currentSelectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }
}
