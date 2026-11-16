import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:task_nest/core/notifications/noti_service.dart';
import 'package:task_nest/core/preferences/user_preferences.dart';
import 'package:task_nest/core/theme/theme.dart';
import 'package:task_nest/feature/onboarding/presentation/screens/onboarding.dart';
import 'package:task_nest/feature/routines/presentation/screens/create_routine.dart';
import 'package:task_nest/feature/routines/presentation/screens/routines_screen.dart';
import 'package:task_nest/feature/settings/presentation/screens/subsettings/about_us_screen.dart';
import 'package:task_nest/feature/settings/presentation/screens/subsettings/notifications_screen.dart';
import 'package:task_nest/feature/skeleton/presentation/screens/skeleton.dart';
import 'package:task_nest/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'en';
  await initializeDateFormatting('en');
  await UserPreferences().initPrefs();
  await NotiService().initNotifications();
  await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TaskNest',
        theme: themeDark,
        themeMode: ThemeMode.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialRoute: '/',
        routes: {
          '/': (context) => const Skeleton(),
          '/onboarding': (context) => OnboardingScreen(),
          '/routines': (context) => RoutinesScreen(),
          '/createRoutine': (context) => const CreateRoutineScreen(),
          '/about': (context) => const AboutUsScreen(),
          '/notifications': (context) => NotificationsScreen(),
        },
      ),
    );
  }
}
