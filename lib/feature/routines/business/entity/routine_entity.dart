// ignore_for_file: public_member_api_docs, sort_constructors_first


// routine_type.dart
enum RoutineType {
  task,
  timed,
  amount;

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
  bool? alarmActive;
  String? alarmTime;
  DateTime? endAt;

  /*
  So the idea is: for the custom alarm, in notifications it'll search for routines that have active alarm on
  and will show it like in 'Tick it'.
  The alarm Id will be the same Id as the routine, so after the routine upsertion will create the noti

  endAt is simple, if not null it will end, if null it doesn't end

  IMPORTANT: this are temporal thought, valorate the idea of making a database of notifications.
  */

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
    this.alarmTime,
    this.alarmActive,
    this.endAt,
  });
}
