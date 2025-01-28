// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

import 'package:wellnest/routines/business/entity/routine_entity.dart';

part 'routine_model.g.dart';

@collection
class RoutineModel {
  Id? id;
  String name;
  List<bool> days;
  bool finished;

  RoutineModel({
    this.id,
    required this.name,
    required this.days,
    required this.finished,
  });

  factory RoutineModel.fromEntity(RoutineEntity routinEntity) => RoutineModel(
      id: routinEntity.id,
      name: routinEntity.name,
      days: routinEntity.days,
      finished: routinEntity.finished);

  RoutineEntity toEntity() =>
      RoutineEntity(id: id, name: name, days: days, finished: finished);
}
