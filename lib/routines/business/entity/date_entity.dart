// ignore_for_file: public_member_api_docs, sort_constructors_first
class DateEntity {
  int id;
  DateTime date;
  List<int> routinesId;
  int completedRoutineAmount;
  
  DateEntity({
    required this.id,
    required this.date,
    required this.routinesId,
    required this.completedRoutineAmount,
  });
}
