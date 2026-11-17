import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:task_nest/core/errors/excpetions.dart';
import 'package:task_nest/feature/routines/data/datasources/remote/routine_remote_datasource.dart';

http.Response _jsonResponse(Object body, int statusCode) {
  return http.Response.bytes(
    utf8.encode(jsonEncode(body)),
    statusCode,
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );
}

void main() {
  group('RoutineRemoteDatasourceImpl', () {
    test('maps the todos payload to task routines', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(
          request.url.toString(),
          'https://jsonplaceholder.typicode.com/todos',
        );

        return _jsonResponse([
          {
            'userId': 1,
            'id': 1,
            'title': 'Buy milk',
            'completed': false,
          },
          {
            'userId': 1,
            'id': 2,
            'title': 'Ship the app',
            'completed': true,
          },
        ], 200);
      });

      final datasource = RoutineRemoteDatasourceImpl(client: client);
      final routines = await datasource.fetchTodos();

      expect(routines, hasLength(2));
      expect(routines.first.name, 'Buy milk');
      expect(routines.first.finished, isFalse);
      expect(routines.first.type, 'task');
      expect(routines.first.days, everyElement(isTrue));
      expect(routines.first.targetCount, 1);
      expect(routines.first.currentCount, 0);
      expect(routines.last.name, 'Ship the app');
      expect(routines.last.finished, isTrue);
    });

    test('throws ServerException when the service answers an error', () async {
      final client = MockClient((_) async => _jsonResponse('error', 500));

      final datasource = RoutineRemoteDatasourceImpl(client: client);

      await expectLater(
        datasource.fetchTodos(),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws ServerException on transport failures', () async {
      final client = MockClient((_) async {
        throw http.ClientException('connection refused');
      });

      final datasource = RoutineRemoteDatasourceImpl(client: client);

      await expectLater(
        datasource.fetchTodos(),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws ServerException when the payload is not a JSON list',
        () async {
      final client = MockClient((_) async => _jsonResponse({'todos': []}, 200));

      final datasource = RoutineRemoteDatasourceImpl(client: client);

      await expectLater(
        datasource.fetchTodos(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
