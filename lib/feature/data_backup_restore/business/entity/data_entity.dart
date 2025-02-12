// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataEntity {
  int id;
  String userId;
  List<Map<String, dynamic>> dates;
  List<Map<String, dynamic>> routines;

  DataEntity({
    required this.id,
    required this.userId,
    required this.dates,
    required this.routines,
  });
}
