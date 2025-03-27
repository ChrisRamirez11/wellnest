// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';

part 'routine_model.g.dart';

@collection
class RoutineModel {
  Id? id;
  String name;
  List<bool> days;
  bool finished;
  DateTime createdDate;
  int? colorValue;

  RoutineModel(
      {this.id,
      required this.name,
      required this.days,
      required this.finished,
      required this.createdDate,
      required this.colorValue});

  factory RoutineModel.fromEntity(RoutineEntity routineEntity) => RoutineModel(
      id: routineEntity.id,
      name: routineEntity.name,
      days: routineEntity.days,
      finished: routineEntity.finished,
      createdDate: routineEntity.createdDate,
      colorValue: routineEntity.colorValue ?? Colors.blue.value);

  RoutineEntity toEntity() => RoutineEntity(
      id: id,
      name: name,
      days: days,
      finished: finished,
      createdDate: createdDate,
      colorValue: colorValue ?? Colors.blue.value);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      /*
    id commented because im using toMap only for storing in supabase the data and to avoid having the repeated Ids when
    backup happens i'll store it in the cloud without id
    */
      // 'id': id,
      'name': name,
      'days': days,
      'finished': finished,
      'createdDate': createdDate.toIso8601String(),
      'colorValue': colorValue ?? Colors.blue.value
    };
  }

  factory RoutineModel.fromMap(Map<String, dynamic> map) => RoutineModel(
        id: map['id'],
        name: map['name'] as String,
        days: List<bool>.from((map['days'] as List)),
        finished: map['finished'] as bool,
        createdDate: DateTime.parse(map['createdDate']),
        colorValue: map['colorValue'] as int,
      );
}
