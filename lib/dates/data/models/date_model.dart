// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:isar/isar.dart';

import 'package:wellnest/dates/business/entity/date_entity.dart';
import 'package:wellnest/routines/business/entity/routine_entity.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';

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


//toMap and fromMap must be checked if its working correctlty (To be used with Supabase)
  Map<String, dynamic> toMap() => <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'routines': routines.map((x) => x.toMap()).toList(),
      'completedRoutineAmount': completedRoutineAmount,
    };

  factory DateModel.fromMap(Map<String, dynamic> map) {
    return DateModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      routines: List<Routine>.from(
        (map['routines'] as List<int>).map<Routine>(
          (x) => Routine.fromMap(x as Map<String, dynamic>),
        ),
      ),
      completedRoutineAmount: map['completedRoutineAmount'] as int,
    );
  }
}


//THIS is for trying to save the RoutineModels into DateModel, and because of the isar database way,
//i cant set embedded to the Model, insted I had to do this
@embedded
class Routine {
  int? id;
  String? name;
  List<bool>? days;
  bool? finished;
  DateTime? createdDate;

  Routine({
    this.id,
    this.name,
    this.days,
    this.finished,
    this.createdDate,
  });

  factory Routine.fromEntity(RoutineEntity routinEntity) => Routine(
      id: routinEntity.id,
      name: routinEntity.name,
      days: routinEntity.days,
      finished: routinEntity.finished,
      createdDate: routinEntity.createdDate);

  RoutineEntity toEntity() => RoutineEntity(
      id: id,
      name: name!,
      days: days!,
      finished: finished!,
      createdDate: createdDate!);

  factory Routine.fromModel(RoutineModel routineModel) => Routine(
      id: routineModel.id,
      name: routineModel.name,
      days: routineModel.days,
      finished: routineModel.finished,
      createdDate: routineModel.createdDate);

  RoutineModel toModel() => RoutineModel(
      id: id,
      name: name!,
      days: days!,
      finished: finished!,
      createdDate: createdDate!);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'days': days,
      'finished': finished,
      'createdDate': createdDate,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) => Routine(
        id: map['id'],
        name: map['name'] as String,
        days: List<bool>.from((map['days'] as List<bool>)),
        finished: map['finished'] as bool,
        createdDate: DateTime.parse(map['createdDate']),
      );
}
