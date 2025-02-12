import 'dart:convert';

import 'package:wellnest/feature/data_backup_restore/business/entity/data_entity.dart';

class DataModel extends DataEntity {
  DataModel(
      {required super.id,
      required super.userId,
      required super.dates,
      required super.routines});

  factory DataModel.fromEntity(DataEntity dataEntity) {
    return DataModel(
        id: dataEntity.id,
        userId: dataEntity.userId,
        dates: dataEntity.dates,
        routines: dataEntity.routines);
  }

  DataEntity toEntity() {
    return DataEntity(id: id, userId: userId, dates: dates, routines: routines);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'dates': dates,
      'routines': routines,
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      dates: List<Map<String, dynamic>>.from(
        (map['dates'] as List).map<Map<String, dynamic>>(
          (x) => x,
        ),
      ),
      routines: List<Map<String, dynamic>>.from(
        (map['routines'] as List).map<Map<String, dynamic>>(
          (x) => x,
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DataModel.fromJson(String source) =>
      DataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
