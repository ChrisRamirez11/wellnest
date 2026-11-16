import 'package:flutter/material.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';

class RoutineCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
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
}
