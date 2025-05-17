// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:wellnest/feature/dates/data/models/date_model.dart';

class CoachRoutineModel {
  final String name;
  final bool finished;
  CoachRoutineModel({required this.name, required this.finished});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'completed': finished,
    };
  }

  factory CoachRoutineModel.fromMap(Map<String, dynamic> map) {
    return CoachRoutineModel(
      name: map['name'] as String,
      finished: map['completed'] as bool,
    );
  }

  factory CoachRoutineModel.fromRoutine(Routine routine) {
    return CoachRoutineModel(name: routine.name!, finished: routine.finished!);
  }
}
