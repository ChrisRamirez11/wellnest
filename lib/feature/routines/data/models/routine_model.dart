// ignore_for_file: public_member_api_docs, sort_constructors_first
// routine_model.dart
import 'package:isar_community/isar.dart';

import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';

part 'routine_model.g.dart';

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
}
