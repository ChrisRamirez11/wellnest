// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

import 'package:wellnest/routines/business/entity/routine_entity.dart';

part 'routine_model.g.dart';

@collection
class RoutineModel {
  Id? id;
  String name;
  int duration;
  List<bool> days;

  RoutineModel({
    this.id,
    required this.name,
    required this.duration,
    required this.days,
  });

  factory RoutineModel.fromEntity(RoutineEntity routinEntity) => RoutineModel(
      id: routinEntity.id,
      name: routinEntity.name,
      duration: routinEntity.duration,
      days: routinEntity.days);

  RoutineEntity toEntity() =>
      RoutineEntity(id: id, name: name, duration: duration, days: days);
}
