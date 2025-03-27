// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:isar/isar.dart';

import 'package:wellnest/feature/dates/business/entity/date_entity.dart';
import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';

part 'date_model.g.dart';

@collection
class DateModel {
  Id? id;
  DateTime date;
  List<Routine> routines;
  int completedRoutineAmount;

  DateModel({
    this.id,
    required this.date,
    required this.routines,
    required this.completedRoutineAmount,
  });

  factory DateModel.fromEntity(DateEntity entity) {
    return DateModel(
      id: entity.id,
      date: entity.date,
      routines: entity.routines
          .map(
            (e) => Routine.fromEntity(e),
          )
          .toList(),
      completedRoutineAmount: entity.completedRoutineAmount,
    );
  }

  DateEntity toEntity() => DateEntity(
      id: id,
      date: date,
      routines: routines
          .map(
            (e) => e.toEntity(),
          )
          .toList(),
      completedRoutineAmount: completedRoutineAmount);

  Map<String, dynamic> toMap() => <String, dynamic>{
        /*
    id commented because im using toMap only for storing in supabase the data and to avoid having the repeated Ids when
    backup happens i'll store it in the cloud without id
    */
        // 'id': id,
        'date': date.toIso8601String(),
        'routines': routines.map((x) => x.toMap()).toList(),
        'completedRoutineAmount': completedRoutineAmount,
      };

  factory DateModel.fromMap(Map<String, dynamic> map) {
    return DateModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      routines: List<Routine>.from(
        (map['routines'] as List).map<Routine>(
          (x) => Routine.fromMap(x as Map<String, dynamic>),
        ),
      ),
      completedRoutineAmount: map['completedRoutineAmount'] as int,
    );
  }
}

@embedded
class Routine {
  int? id;
  String? name;
  List<bool>? days;
  bool? finished;
  DateTime? createdDate;
  int? colorValue;

  Routine({
    this.id,
    this.name,
    this.days,
    this.finished,
    this.createdDate,
    this.colorValue,
  });

  factory Routine.fromEntity(RoutineEntity routineEntity) => Routine(
      id: routineEntity.id,
      name: routineEntity.name,
      days: routineEntity.days,
      finished: routineEntity.finished,
      createdDate: routineEntity.createdDate,
      colorValue: routineEntity.colorValue);

  RoutineEntity toEntity() => RoutineEntity(
      id: id,
      name: name!,
      days: days!,
      finished: finished!,
      createdDate: createdDate!,
      colorValue: colorValue!);

  factory Routine.fromModel(RoutineModel routineModel) => Routine(
      id: routineModel.id,
      name: routineModel.name,
      days: routineModel.days,
      finished: routineModel.finished,
      createdDate: routineModel.createdDate,
      colorValue: routineModel.colorValue);

  RoutineModel toModel() => RoutineModel(
      id: id,
      name: name!,
      days: days!,
      finished: finished!,
      createdDate: createdDate!,
      colorValue: colorValue!);

  factory Routine.fromMap(Map<String, dynamic> map) => Routine(
        id: map['id'],
        name: map['name'] as String,
        days: List<bool>.from((map['days'] as List)),
        finished: map['finished'] as bool,
        createdDate: DateTime.parse(map['createdDate']),
        colorValue: map['colorValue'] as int,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'days': days,
      'finished': finished,
      'createdDate': createdDate!.toIso8601String(),
      'colorValue': colorValue
    };
  }
}
