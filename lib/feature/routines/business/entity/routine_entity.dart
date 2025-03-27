// ignore_for_file: public_member_api_docs, sort_constructors_first

class RoutineEntity {
  int? id;
  String name;
  List<bool> days;
  bool finished;
  DateTime createdDate;
  int colorValue;
  
  RoutineEntity({
    this.id,
    required this.name,
    required this.days,
    required this.finished,
    required this.createdDate,
    required this.colorValue,
  });
}
