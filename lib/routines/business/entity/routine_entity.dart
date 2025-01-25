// ignore_for_file: public_member_api_docs, sort_constructors_first

class RoutineEntity {
  int? id;
  String name;
  int duration;
  String type;
  
  RoutineEntity({
    this.id,
    required this.name,
    required this.duration,
    required this.type,
  });
}
