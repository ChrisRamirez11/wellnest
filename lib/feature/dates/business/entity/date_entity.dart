// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';

class DateEntity {
  int? id;
  DateTime date;
  List<RoutineEntity> routines;
  int completedRoutineAmount;

  DateEntity({
    this.id,
    required this.date,
    required this.routines,
    required this.completedRoutineAmount,
  });
}
