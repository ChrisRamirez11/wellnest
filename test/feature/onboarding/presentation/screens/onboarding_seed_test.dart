import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:task_nest/core/errors/failures.dart';
import 'package:task_nest/core/preferences/user_preferences.dart';
import 'package:task_nest/feature/onboarding/presentation/screens/onboarding.dart';
import 'package:task_nest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:task_nest/l10n/app_localizations.dart';

import '../../../../helpers/fake_routine_repository.dart';

Future<ProviderContainer> _pumpOnboarding(
  WidgetTester tester, {
  required FakeRoutineRepository repository,
}) async {
  final routineNotifier = RoutineProvider(
    routineRepository: repository,
    loadRoutinesOnCreate: false,
  );
  final container = ProviderContainer(
    overrides: [routineProvider.overrideWith((ref) => routineNotifier)],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        initialRoute: '/onboarding',
        routes: {
          '/onboarding': (_) => const OnboardingScreen(),
          '/': (_) => const Scaffold(body: Text('home')),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  return container;
}

Future<void> _finishOnboarding(WidgetTester tester) async {
  for (var page = 0; page < 3; page++) {
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
  }

  await tester.tap(find.text('FINISH'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await UserPreferences().initPrefs();

    AndroidFlutterLocalNotificationsPlugin.registerWith();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      (MethodCall call) async => null,
    );
  });

  testWidgets('finishing onboarding seeds routines from the API',
      (tester) async {
    final repository = FakeRoutineRepository();
    final container = await _pumpOnboarding(tester, repository: repository);

    await _finishOnboarding(tester);

    expect(repository.seedCalls, 1);
    expect(find.text('home'), findsOneWidget);
    expect(container.read(routineProvider).apiSeedError, isNull);
  });

  testWidgets('a network error does not block onboarding and is recorded',
      (tester) async {
    final repository = FakeRoutineRepository(
      seedResult: Left(NetworkFailure(errorMessage: 'offline')),
    );
    final container = await _pumpOnboarding(tester, repository: repository);

    await _finishOnboarding(tester);

    expect(find.text('home'), findsOneWidget);
    expect(container.read(routineProvider).apiSeedError, 'offline');
  });
}
