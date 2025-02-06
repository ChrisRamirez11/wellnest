import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/consts/consts.dart';
import 'package:wellnest/core/shared_preferences/user_preferences.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/skeleton/presentation/screens/skeleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(url: Consts.supabaseUrl, anonKey: Consts.anonKey);
  } catch (e) {
    debugPrint(e.toString());
  }
  await UserPreferences().initPrefs();
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
      },
    );
  }
}
