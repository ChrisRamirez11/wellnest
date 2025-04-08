import 'package:intl/date_symbol_data_local.dart';
import 'package:wellnest/core/global_providers/is_premium_user_provider.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/first_app_opening.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/onboarding.dart';
import 'package:wellnest/feature/settings/presentation/screens/subsettings/notifications_screen.dart';
import 'package:wellnest/purchase_observer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        alwaysUse24HourFormat: true,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WellNest',
        theme: theme,
        darkTheme: themeDark,
        themeMode: ThemeMode.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: ref
            .watch(localeProvider)
            .locale, // Use the locale from provider, if null, uses device language as default
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialRoute:
            ref.watch(firstTimeOpening).firstTimeOpening ? 'onboarding' : '/',
        routes: {
          '/': (context) => const Skeleton(),
          'onboarding': (context) => OnboardingScreen(),
          '/createRoutine': (context) => const CreateRoutineScreen(),
          '/about': (context) => const AboutUsScreen(),
          '/feedback': (context) => FeedbackScreen(),
          '/community': (context) => CommunityScreen(),
          '/notifications': (context) => NotificationsScreen(),
        },
      ),
    );
  }
}