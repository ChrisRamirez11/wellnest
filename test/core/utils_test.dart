import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnest/core/utils/can_update_checkbox.dart';
import 'package:wellnest/core/utils/capitalize_first_letter.dart';
import 'package:wellnest/core/utils/format_duration.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';

void main() {
  group('formatDuration', () {
    test('formats hours, minutes and seconds with two digits', () {
      expect(formatDuration(0), '00:00:00');
      expect(formatDuration(65), '00:01:05');
      expect(formatDuration(3661), '01:01:01');
    });
  });

  group('stringToTimeOfDay', () {
    test('parses a HH:mm string', () {
      expect(stringToTimeOfDay('22:30'), const TimeOfDay(hour: 22, minute: 30));
    });

    test('throws FormatException for invalid input', () {
      expect(() => stringToTimeOfDay('22'), throwsFormatException);
      expect(() => stringToTimeOfDay('aa:bb'), throwsFormatException);
    });
  });

  group('canUpdateCheckbox', () {
    test('allows today and past days', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      expect(canUpdateCheckbox(today), isTrue);
      expect(
          canUpdateCheckbox(today.subtract(const Duration(days: 1))), isTrue);
    });

    test('rejects future days', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      expect(canUpdateCheckbox(today.add(const Duration(days: 1))), isFalse);
    });
  });

  group('capitalizeFirstLetter', () {
    test('capitalizes only the first letter', () {
      expect(capitalizeFirstLetter('monday'), 'Monday');
      expect(capitalizeFirstLetter(''), '');
    });
  });
}
