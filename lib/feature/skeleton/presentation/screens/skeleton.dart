import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/notifications_provider.dart';
import 'package:wellnest/feature/ads/app_open_ad/app_lifecycle.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/first_app_opening.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/onboarding.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/settings/presentation/screens/settings_screen.dart';
import 'package:wellnest/feature/calendar/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/feature/calendar/presentation/screens/small_routines_screen.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/feature/skeleton/presentation/widgets/custom_nav_bar.dart';

List<Widget> pages = [
  const SmallRoutinesScreen(),
  const SettingsScreen(),
];

class Skeleton extends ConsumerStatefulWidget {
  const Skeleton({super.key});

  @override
  ConsumerState<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends ConsumerState<Skeleton> {
  late AppLifecycleReactor appLifecycleReactor;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    //TODO make this ad available again for when the app have a lot of users
    /*
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: appOpenAdManager);
      */
  }

  @override
  Future<void> didChangeDependencies() async {
    final prefs = UserPreferences();
    super.didChangeDependencies();

    //scheduled notifications
    if (!prefs.firstTimeNotiSetted) {
      await setGlobalAppNotification(ref, context);

      prefs.firstTimeNotiSetted = true;
      ref
          .watch(notificationProvider)
          .changeValue(await Permission.notification.isGranted);
    }
    //dates and routines related
    await ref.watch(routineProvider).getRoutines();
    await ref.watch(dateProvider).getDates();
    await validateDateModel(ref.watch(routineProvider).routines!,
        ref.watch(currentSelectedDateProvider).currentSelectedDate, ref);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(firstTimeOpening).firstTimeOpening) {
      return const OnboardingScreen();
    }

    final index = ref.watch(indexProvider);
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: CustomNavBar(
              pageController: _pageController,
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: (value) => index.changeIndex(value),
              children: pages,
            )));
  }
}
