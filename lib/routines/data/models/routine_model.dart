// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

import 'package:wellnest/routines/business/entity/routine_entity.dart';

part 'routine_model.g.dart';

@collection
class RoutineModel {
  Id? id;
  String name;
  List<bool> days;
  bool finished;
  DateTime createdDate;

  RoutineModel({
    this.id,
    required this.name,
    required this.days,
    required this.finished,
    required this.createdDate,
  });

  factory RoutineModel.fromEntity(RoutineEntity routinEntity) => RoutineModel(
      id: routinEntity.id,
      name: routinEntity.name,
      days: routinEntity.days,
      finished: routinEntity.finished,
      createdDate: routinEntity.createdDate);

  RoutineEntity toEntity() => RoutineEntity(
      id: id,
      name: name,
      days: days,
      finished: finished,
      createdDate: createdDate);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'days': days,
      'finished': finished,
      'createdDate': createdDate,
    };
  }

  factory RoutineModel.fromMap(Map<String, dynamic> map) => RoutineModel(
        id: map['id'],
        name: map['name'] as String,
        days: List<bool>.from((map['days'] as List<bool>)),
        finished: map['finished'] as bool,
        createdDate: DateTime.parse(map['createdDate']),
      );
}
