// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';
import 'package:wellnest/dates/business/entity/date_entity.dart';

part 'date_model.g.dart';

@collection
class DateModel {
  Id? id;
  DateTime date;
  List<int> routinesId;
  int completedRoutineAmount;

  DateModel({
    this.id,
    required this.date,
    required this.routinesId,
    required this.completedRoutineAmount,
  });

  factory DateModel.fromEntity(DateEntity entity) {
    return DateModel(
      id: entity.id,
      date: entity.date,
      routinesId: entity.routinesId,
      completedRoutineAmount: entity.completedRoutineAmount,
    );
  }
  DateEntity toEntity() => DateEntity(
      date: date,
      routinesId: routinesId,
      completedRoutineAmount: completedRoutineAmount);
}
