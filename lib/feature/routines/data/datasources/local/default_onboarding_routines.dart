import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wellnest/feature/calendar/data/models/routine_category.dart';

class DefaultOnboardingRoutines {
    Future<List<RoutineCategory>> loadRoutines() async {
    final jsonString = await rootBundle.loadString('assets/data/routines.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final categories = (jsonMap['categories'] as List)
        .map((e) => RoutineCategory.fromJson(e))
        .toList();

    return categories;
  }
}