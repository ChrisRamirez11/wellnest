// ignore_for_file: public_member_api_docs, sort_constructors_first


// routine_type.dart
enum RoutineType {
  task,
  timed,
  counted;

  String get name => toString().split('.').last;
}
// routine_entity.dart
class RoutineEntity {
  int? id;
  String name;
  List<bool> days;
  bool finished;
  DateTime createdDate;
  int colorValue;
  String type;
  int targetCount;
  int currentCount;
  int targetDuration;
  int elapsedTime;

  RoutineEntity({
    this.id,
    required this.name,
    required this.days,
    required this.finished,
    required this.createdDate,
    required this.colorValue,
    required this.type,
    required this.targetCount,
    required this.currentCount,
    required this.targetDuration,
    required this.elapsedTime,
  });
}
