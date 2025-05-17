// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:wellnest/feature/ai_coach/data/models/coach_routine_model.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';

class DayInfoModel {
  final DateTime date;
  final List<CoachRoutineModel> coachRoutines;

  DayInfoModel({
    required this.date,
    required this.coachRoutines,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'coachRoutine': coachRoutines.map((x) => x.toMap()).toList(),
    };
  }

  factory DayInfoModel.fromMap(Map<String, dynamic> map) {
    return DayInfoModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      coachRoutines: List<CoachRoutineModel>.from(
        (map['coachRoutine'] as List<int>).map<CoachRoutineModel>(
          (x) => CoachRoutineModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory DayInfoModel.fromDateModel(DateModel date) {
    return DayInfoModel(
        date: date.date,
        coachRoutines: date.routines
            .map(
              (e) => CoachRoutineModel.fromRoutine(e),
            )
            .toList());
  }
}
