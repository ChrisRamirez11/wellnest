import 'package:wellnest/feature/ai_coach/business/entity/coach_routine_entity.dart';

class DayInfo {
  final DateTime date;
  final List<CoachRoutineEntity> coachRoutine;

  DayInfo({
    required this.date,
    required this.coachRoutine,
  });
}
