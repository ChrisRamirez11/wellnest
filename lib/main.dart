import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/routines/presentation/screens/create_routine.dart';
import 'package:wellnest/skeleton/presentation/screens/skeleton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WellNest',
        theme: theme,
        darkTheme: themeDark,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const Skeleton(),
          '/createRoutine': (context) => const CreateRoutineScreen(),
        },
      ),
    );
  }
}
