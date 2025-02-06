import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/shared_preferences/user_preferences.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/settings/presentation/providers/dark_mode_provider.dart';
import 'package:wellnest/skeleton/presentation/screens/skeleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPreferences().initPrefs();
  runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WellNest',
        theme: theme,
        darkTheme: themeDark,
        themeMode: ref.watch(darkModeProvider).darkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const Skeleton(),
          '/createRoutine': (context) => const CreateRoutineScreen(),
        },
      ),
    );
  }
}
