// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import 'package:task_nest/feature/dates/business/entity/date_entity.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';
import 'package:task_nest/feature/routines/data/models/routine_model.dart';

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
}

@embedded
class Routine {
  int? id;
  String? name;
  List<bool>? days;
  bool? finished;
  DateTime? createdDate;
  int? colorValue;
  String? type;
  int? targetCount;
  int? currentCount;
  int? targetDurationSeconds;
  int? elapsedTimeSeconds;
  String? alarmTime;
  bool? alarmActive;
  DateTime? endAt;

  Routine({
    this.id,
    this.name,
    this.days,
    this.finished,
    this.createdDate,
    this.colorValue,
    this.type,
    this.targetCount,
    this.currentCount,
    this.targetDurationSeconds,
    this.elapsedTimeSeconds,
    this.alarmTime,
    this.alarmActive,
    this.endAt,
  });

  factory Routine.fromModel(RoutineModel model) => Routine(
      id: model.id,
      name: model.name,
      days: model.days,
      finished: model.finished,
      createdDate: model.createdDate,
      colorValue: model.colorValue,
      type: model.type,
      targetCount: model.targetCount,
      currentCount: model.currentCount,
      targetDurationSeconds: model.targetDurationSeconds,
      elapsedTimeSeconds: model.elapsedTimeSeconds,
      alarmActive: model.alarmActive,
      alarmTime: model.alarmTime,
      endAt: model.endAt);

  factory Routine.fromEntity(RoutineEntity entity) => Routine(
      id: entity.id,
      name: entity.name,
      days: entity.days,
      finished: entity.finished,
      createdDate: entity.createdDate,
      colorValue: entity.colorValue,
      type: entity.type,
      targetCount: entity.targetCount,
      currentCount: entity.currentCount,
      targetDurationSeconds: entity.targetDuration,
      elapsedTimeSeconds: entity.elapsedTime,
      alarmActive: entity.alarmActive,
      alarmTime: entity.alarmTime,
      endAt: entity.endAt);

  RoutineEntity toEntity() => RoutineEntity(
      id: id,
      name: name!,
      days: days ?? List.filled(7, false),
      finished: finished ?? false,
      createdDate: createdDate!,
      colorValue: colorValue ?? Colors.blue.toARGB32(),
      type: type ?? RoutineType.task.name,
      targetCount: targetCount ?? 1,
      currentCount: currentCount ?? 0,
      targetDuration: targetDurationSeconds ?? 0,
      elapsedTime: elapsedTimeSeconds ?? 0,
      alarmActive: alarmActive ?? false,
      alarmTime: alarmTime,
      endAt: endAt);

  RoutineModel toModel() => RoutineModel(
      id: id,
      name: name!,
      days: days ?? List.filled(7, false),
      finished: finished ?? false,
      createdDate: createdDate!,
      colorValue: colorValue ?? Colors.blue.toARGB32(),
      type: type ?? RoutineType.task.name,
      targetCount: targetCount ?? 1,
      currentCount: currentCount ?? 0,
      targetDurationSeconds: targetDurationSeconds ?? 0,
      elapsedTimeSeconds: elapsedTimeSeconds ?? 0,
      alarmActive: alarmActive ?? false,
      alarmTime: alarmTime,
      endAt: endAt);
}
