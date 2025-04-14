// routine_model.dart
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
  String type;
  int? targetCount;
  int currentCount;
  int? targetDurationSeconds;
  int elapsedTimeSeconds;

  RoutineModel({
    this.id,
    required this.name,
    required this.days,
    required this.finished,
    required this.createdDate,
    required this.colorValue,
    required this.type,
    this.targetCount,
    this.currentCount = 0,
    this.targetDurationSeconds,
    this.elapsedTimeSeconds = 0,
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
      );

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
      );

  factory RoutineModel.fromMap(Map<String, dynamic> map) => RoutineModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        days: List<bool>.from(map['days'] as List),
        finished: map['finished'] as bool,
        createdDate: DateTime.parse(map['createdDate'] as String),
        colorValue: map['colorValue'] as int?,
        type: RoutineType.values.byName(map['type'] as String).name,
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
        'createdDate': createdDate.toIso8601String(),
        'colorValue': colorValue,
        'type': type,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'targetDuration': targetDurationSeconds,
        'elapsedTime': elapsedTimeSeconds,
      };

  RoutineModel copyWith({
    Id? id,
    String? name,
    List<bool>? days,
    bool? finished,
    DateTime? createdDate,
    int? colorValue,
    String? type,
    int? targetCount,
    int? currentCount,
    int? targetDurationSeconds,
    int? elapsedTimeSeconds,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      finished: finished ?? this.finished,
      createdDate: createdDate ?? this.createdDate,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      targetDurationSeconds:
          targetDurationSeconds ?? this.targetDurationSeconds,
      elapsedTimeSeconds: elapsedTimeSeconds ?? this.elapsedTimeSeconds,
    );
  }

//TODO use it, if it fits
  bool _isCompleted() {
    switch (RoutineType.values.byName(type)) {
      case RoutineType.counted:
        return currentCount >= (targetCount ?? 1);
      case RoutineType.timed:
        return elapsedTimeSeconds >= (targetDurationSeconds ?? 0);
      case RoutineType.task:
        return finished;
    }
  }
}
