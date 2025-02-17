import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/consts/consts.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/feature/settings/presentation/screens/subsettings/about_us_screen.dart';
import 'package:wellnest/feature/settings/presentation/screens/subsettings/community_screen.dart';
import 'package:wellnest/feature/settings/presentation/screens/subsettings/feedback_screen.dart';
import 'package:wellnest/feature/skeleton/presentation/screens/skeleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(url: Consts.supabaseUrl, anonKey: Consts.anonKey);
  } catch (e) {
    debugPrint(e.toString());
  }

  if (supabase.auth.currentSession != null) {
    try {
      supabase.auth.refreshSession();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  await UserPreferences().initPrefs();
  await NotiService().initNotifications();
  
  await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();

  runApp(const ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WellNest',
      theme: theme,
      darkTheme: themeDark,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const Skeleton(),
        '/createRoutine': (context) => const CreateRoutineScreen(),
        '/about': (context) => const AboutUsScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/community': (context) => CommunityScreen(),
      },
    );
  }
}
