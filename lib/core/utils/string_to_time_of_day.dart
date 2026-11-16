import 'package:flutter/material.dart';

TimeOfDay stringToTimeOfDay(String s) {
  final parts = s.split(':');
  if (parts.length != 2) {
    throw FormatException('Invalid time format, expected HH:mm');
  }
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
