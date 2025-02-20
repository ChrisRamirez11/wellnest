import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/ads/app_open_ad/app_lifecycle.dart';
import 'package:wellnest/ads/app_open_ad/app_open_ad.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/screens/routines_screen.dart';
import 'package:wellnest/feature/settings/presentation/screens/settings_screen.dart';
import 'package:wellnest/feature/small_routines/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/feature/small_routines/presentation/screens/small_routines_screen.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/feature/skeleton/presentation/widgets/custom_nav_bar.dart';

List<Widget> pages = [
  const SmallRoutinesScreen(),
  const RoutinesScreen(),
  const SettingsScreen(),
];

class Skeleton extends ConsumerStatefulWidget {
  const Skeleton({super.key});

  @override
  ConsumerState<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends ConsumerState<Skeleton> {
  late AppLifecycleReactor appLifecycleReactor;

  @override
  void initState() {
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: appOpenAdManager);
  }
  
  @override
  Future<void> didChangeDependencies() async {
    final prefs = UserPreferences();
    super.didChangeDependencies();

    //scheduled notifications
    if (!prefs.firstTimeNotiSetted) {
      await NotiService().scheduleNotification(
          title: 'Good Morning',
          body:
              'Review your daily routines and finish them as you go. Dont forget mark them as done',
          hour: 6,
          minute: 0);

      await NotiService().scheduleNotification(
          title: 'Hey There',
          body:
              'End your day by reviewing unfinished tasks and wrapping them up.',
          hour: 17,
          minute: 0);
          prefs.firstTimeNotiSetted = true;
    }
    //dates and routines related
    await ref.watch(routineProvider).getRoutines();
    await ref.watch(dateProvider).getDates();
    await validateDateModel(ref.watch(routineProvider).routines!,
        ref.watch(currentSelectedDateProvider).currentSelectedDate, ref);
  }

  @override
  void dispose() {
    ref.watch(indexProvider).pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: const CustomNavBar(),
            body: PageView(
              controller: index.pageController,
              onPageChanged: (value) => index.changeIndex(value),
              children: pages,
            )));
  }
}
