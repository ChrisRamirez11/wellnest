import 'main_imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
        url: Consts.supabaseUrl,
        anonKey: Consts.anonKey,
        authOptions:
            const FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce));
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

  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration =
      RequestConfiguration(testDeviceIds: [Consts.pixel7, Consts.samsung]);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  await UserPreferences().initPrefs();
  await NotiService().initNotifications();

  await AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(const ProviderScope(child: MyApp())),
  );
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
