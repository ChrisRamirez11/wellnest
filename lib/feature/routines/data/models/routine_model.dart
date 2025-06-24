// ignore_for_file: public_member_api_docs, sort_constructors_first
// routine_model.dart
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';

part 'routine_model.g.dart';

final now = DateTime.now();

@collection
class RoutineModel {
  Id? id;
  String name;
  List<bool> days;
  bool finished;
  DateTime createdDate;
  int colorValue;
  String type;
  int targetCount;
  int currentCount;
  int targetDurationSeconds;
  int elapsedTimeSeconds;
  String? alarmTime;
  bool? alarmActive;
  DateTime? endAt;

  RoutineModel({
    this.id,
    required this.name,
    required this.days,
    required this.finished,
    required this.createdDate,
    required this.colorValue,
    required this.type,
    required this.targetCount,
    required this.currentCount,
    required this.targetDurationSeconds,
    required this.elapsedTimeSeconds,
    this.alarmTime,
    this.alarmActive,
    this.endAt,
  });

  factory RoutineModel.fromEntity(RoutineEntity entity) => RoutineModel(
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
      name: name,
      days: days,
      finished: finished,
      createdDate: createdDate,
      colorValue: colorValue,
      type: RoutineType.values.byName(type).name,
      targetCount: targetCount,
      currentCount: currentCount,
      targetDuration: targetDurationSeconds,
      elapsedTime: elapsedTimeSeconds,
      alarmActive: alarmActive,
      alarmTime: alarmTime,
      endAt: endAt);

  factory RoutineModel.fromMap(Map<String, dynamic> map) => RoutineModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      days: List<bool>.from(map['days'] as List),
      finished: map['finished'] as bool,
      createdDate: map['createdDate'] != null &&
              (map['createdDate'] as String).isNotEmpty
          ? DateTime.parse(map['createdDate'] as String)
          : DateTime(now.year, now.month, now.day),
      colorValue: map['colorValue'] as int? ?? Colors.blue.value,
      type: RoutineType.values
          .byName(map['type'] as String? ?? RoutineType.task.name)
          .name,
      targetCount: map['targetCount'] as int? ?? 1,
      currentCount: map['currentCount'] as int? ?? 0,
      targetDurationSeconds: map['targetDuration'] as int? ?? 0,
      elapsedTimeSeconds: map['elapsedTime'] as int? ?? 0,
      alarmActive: map['alarmActive'] as bool? ?? false,
      alarmTime: map['alarmTime'] as String? ?? '',
      endAt:
          map['endAt'] != null ? DateTime.parse(map['endAt'] as String) : null);

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'name': name,
        'days': days,
        'finished': finished,
        'createdDate': createdDate.toIso8601String(),
        'colorValue': colorValue,
        'type': type,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'targetDuration': targetDurationSeconds,
        'elapsedTime': elapsedTimeSeconds,
        'alarmActive': alarmActive,
        'alarmTime': alarmTime,
        'endAt': endAt?.toIso8601String(),
      };
}
