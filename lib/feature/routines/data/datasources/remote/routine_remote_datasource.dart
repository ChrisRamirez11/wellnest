import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_nest/core/errors/excpetions.dart';
import 'package:task_nest/feature/routines/business/entity/routine_entity.dart';

abstract class RoutineRemoteDatasource {
  Future<List<RoutineEntity>> fetchTodos();
}

/// Fetches the seed tasks from the public JSONPlaceholder service and maps
/// every `todo` to a routine that can be stored locally.
class RoutineRemoteDatasourceImpl implements RoutineRemoteDatasource {
  RoutineRemoteDatasourceImpl({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? defaultBaseUrl;

  static const String defaultBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const String todosPath = '/todos';

  /// Color used for every imported task (Material blue).
  static const int defaultColorValue = 0xFF2196F3;

  final http.Client _client;
  final String _baseUrl;

  @override
  Future<List<RoutineEntity>> fetchTodos() async {
    final Uri uri = Uri.parse('$_baseUrl$todosPath');

    final http.Response response;
    try {
      response = await _client.get(uri);
    } on http.ClientException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }

    if (response.statusCode != 200) {
      throw ServerException(
        message: 'The task service answered with status '
            '${response.statusCode}.',
      );
    }

    final List<dynamic> decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    } catch (_) {
      throw ServerException(
        message: 'The task service returned an unexpected response.',
      );
    }

    final DateTime now = DateTime.now();
    final DateTime createdDate = DateTime(now.year, now.month, now.day);

    return decoded
        .whereType<Map<String, dynamic>>()
        .map((todo) => _todoToRoutine(todo, createdDate))
        .toList();
  }

  RoutineEntity _todoToRoutine(
    Map<String, dynamic> todo,
    DateTime createdDate,
  ) {
    final Object? title = todo['title'];
    final Object? completed = todo['completed'];

    return RoutineEntity(
      name: title is String && title.trim().isNotEmpty
          ? title.trim()
          : 'Untitled task',
      days: const [true, true, true, true, true, true, true],
      finished: completed is bool ? completed : false,
      createdDate: createdDate,
      colorValue: defaultColorValue,
      type: RoutineType.task.name,
      targetCount: 1,
      currentCount: 0,
      targetDuration: 0,
      elapsedTime: 0,
      alarmActive: false,
      alarmTime: null,
      endAt: null,
    );
  }
}
