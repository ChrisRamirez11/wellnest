// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
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
  String? type;
  int? targetCount;
  int? currentCount;
  int? targetDurationSeconds;
  int? elapsedTimeSeconds;

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
      );

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
      );

  RoutineEntity toEntity() => RoutineEntity(
        id: id,
        name: name!,
        days: days ?? List.filled(7, false),
        finished: finished ?? false,
        createdDate: createdDate!,
        colorValue: colorValue ?? Colors.blue.value,
        type: type ?? RoutineType.task.name,
        targetCount: targetCount ?? 1,
        currentCount: currentCount ?? 0,
        targetDuration: targetDurationSeconds ?? 0,
        elapsedTime: elapsedTimeSeconds ?? 0,
      );

  RoutineModel toModel() => RoutineModel(
        id: id,
        name: name!,
        days: days ?? List.filled(7, false),
        finished: finished ?? false,
        createdDate: createdDate!,
        colorValue: colorValue ?? Colors.blue.value,
        type: type ?? RoutineType.task.name,
        targetCount: targetCount ?? 1,
        currentCount: currentCount ?? 0,
        targetDurationSeconds: targetDurationSeconds ?? 0,
        elapsedTimeSeconds: elapsedTimeSeconds ?? 0,
      );

  factory Routine.fromMap(Map<String, dynamic> map) => Routine(
        id: map['id'] as int?,
        name: map['name'] as String?,
        days: List<bool>.from(map['days'] as List? ?? []),
        finished: map['finished'] as bool? ?? false,
        createdDate: map['createdDate'] != null
            ? DateTime.parse(map['createdDate'] as String)
            : null,
        colorValue: map['colorValue'] as int?,
        type: map['type'] as String,
        targetCount: map['targetCount'] as int?,
        currentCount: map['currentCount'] as int? ?? 0,
        targetDurationSeconds: map['targetDuration'] as int?,
        elapsedTimeSeconds: map['elapsedTime'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'days': days,
        'finished': finished,
        'createdDate': createdDate?.toIso8601String(),
        'colorValue': colorValue,
        'type': type,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'targetDuration': targetDurationSeconds,
        'elapsedTime': elapsedTimeSeconds,
      };
}
