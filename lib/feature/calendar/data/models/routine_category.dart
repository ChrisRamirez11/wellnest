import 'package:flutter/material.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';

class RoutineCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final List<RoutineModel> routines;

  RoutineCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.routines,
  });

  factory RoutineCategory.fromJson(Map<String, dynamic> json) {
    return RoutineCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: Color(int.parse(json['color'].substring(1, 7), radix: 16) + 0xFF000000),
      routines: (json['routines'] as List)
          .map((routine) => RoutineModel.fromMap(routine))
          .toList(),
    );
  }
}