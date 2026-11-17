import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_nest/core/notifications/global_app_notification.dart';
import 'package:task_nest/core/notifications/notifications_provider.dart';
import 'package:task_nest/core/preferences/user_preferences.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/core/utils/validate_date_model_creation.dart.dart';
import 'package:task_nest/feature/calendar/presentation/providers/current_selected_date_provider.dart';
import 'package:task_nest/feature/calendar/presentation/screens/small_routines_screen.dart';
import 'package:task_nest/feature/dates/presentation/providers/date_provider.dart';
import 'package:task_nest/feature/onboarding/presentation/provider/first_app_opening.dart';
import 'package:task_nest/feature/onboarding/presentation/screens/onboarding.dart';
import 'package:task_nest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:task_nest/feature/settings/presentation/screens/settings_screen.dart';
import 'package:task_nest/feature/skeleton/presentation/providers/index_provider.dart';
import 'package:task_nest/feature/skeleton/presentation/widgets/custom_nav_bar.dart';

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
  final PageController _pageController = PageController();
  bool _apiSeedErrorScheduled = false;

  @override
  Future<void> didChangeDependencies() async {
    final prefs = UserPreferences();
    super.didChangeDependencies();

    // Scheduled notifications
    if (!prefs.firstTimeNotiSetted) {
      await setGlobalAppNotification(ref, context);

      prefs.firstTimeNotiSetted = true;
      ref
          .watch(notificationProvider)
          .changeValue(await Permission.notification.isGranted);
    }
    // Dates and routines related
    await ref.watch(routineProvider).getRoutines();
    await ref.watch(dateProvider).getDates();
    await validateDateModel(
      ref.watch(routineProvider).routines!,
      ref.watch(currentSelectedDateProvider).currentSelectedDate,
      ref,
    );

    _showApiSeedError();
  }

  void _showApiSeedError() {
    if (_apiSeedErrorScheduled) return;

    final routineNotifier = ref.read(routineProvider);
    final error = routineNotifier.apiSeedError;
    if (error == null) return;

    _apiSeedErrorScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _apiSeedErrorScheduled = false;
      if (!mounted) return;

      ref.read(routineProvider).clearApiSeedError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localization(context).apiSeedError(error)),
        ),
      );
    });
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
        bottomNavigationBar: CustomNavBar(pageController: _pageController),
        body: PageView(
          controller: _pageController,
          onPageChanged: (value) => index.changeIndex(value),
          children: pages,
        ),
      ),
    );
  }
}
