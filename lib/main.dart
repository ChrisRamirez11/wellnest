import 'package:intl/date_symbol_data_local.dart';
import 'package:wellnest/core/global_providers/is_premium_user_provider.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/onboarding.dart';
import 'package:wellnest/purchase_observer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    PurchasesObserver(ref: ref).initialize();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // Set your desired locale
    String? locale = ref.watch(localeProvider).locale?.languageCode; // Spanish
    // Initialize locale data
    await initializeDateFormatting(locale, null);

    final isPremiumNotifier = ref.watch(isPremiumUser);
    await isPremiumNotifier.premiumSetter();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WellNest',
      theme: theme,
      darkTheme: themeDark,
      themeMode: ThemeMode.dark,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider).locale, // Use the locale from provider
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // initialRoute: ref.watch(firstTimeOpening).firstTimeOpening ? 'onboarding' : '/',
      initialRoute: 'onboarding',
      routes: {
        '/': (context) => const Skeleton(),
        'onboarding': (context) => OnboardingScreen(),
        '/createRoutine': (context) => const CreateRoutineScreen(),
        '/about': (context) => const AboutUsScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/community': (context) => CommunityScreen(),
      },
    );
  }
}
