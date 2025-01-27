// ignore_for_file: public_member_api_docs, sort_constructors_first

class RoutineEntity {
  int? id;
  String name;
  int duration;
  List<bool> days;
  
  RoutineEntity({
    this.id,
    required this.name,
    required this.duration,
    required this.days,
  });
}
