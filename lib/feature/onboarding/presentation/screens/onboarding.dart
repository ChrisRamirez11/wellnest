import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/utils/show_paywall.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/categories_provider.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/first_app_opening.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/onboarding_page_one.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/onboarding_page_two.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/select_category_screen.dart';
import 'package:wellnest/feature/onboarding/presentation/screens/select_routines_screen.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';

import '../../../../core/theme/theme.dart';

const int _pageChangeSpeed = 200;

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPageIndex = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await NotiService().cancelAllNotifications();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      OnboardingPageOne(),
      OnboardingPageTwo(),
      SelectCategoriesScreen(),
      SelectRoutinesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 50,
        actions: [SizedBox(width: 50)],
        centerTitle: true,
        title: _buildProgressIndicator(pages.length),
        leading: _currentPageIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: _pageChangeSpeed),
                    curve: Curves.linear,
                  );
                },
              )
            : SizedBox(),
      ),
      bottomNavigationBar: getButtons(context, pages.length),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
    );
  }

  Padding getButtons(BuildContext context, int totalPages) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: _currentPageIndex != (totalPages - 1)
          ? CustomButton(
              color: Colors.blue,
              textColor: ghostWhite,
              onClick: () {
                _controller.nextPage(
                  duration: Duration(milliseconds: _pageChangeSpeed),
                  curve: Curves.easeIn,
                );
              },
              text: localization(context).next.toUpperCase())
          : CustomButton(
              color: Colors.blue,
              textColor: ghostWhite,
              onClick: () async {
                // when FINISH is hitted, is when it understands the first step of the app was succesful
                ref.watch(firstTimeOpening).appOpened();

                // Inserts the default selected routines
                final routinesList = (ref
                            .watch(selectedCategoryProvider.notifier)
                            .state
                            ?.routines ??
                        [])
                    .where(
                      (routine) => ref.watch(selectedRoutinesProvider).any(
                            (name) => name!.contains(routine.name),
                          ),
                    )
                    .toList();

                await ref
                    .watch(routineProvider)
                    .upsertAllRoutines(routinesList);

                showPaywall();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                }
              },
              text: localization(context).finish.toUpperCase()),
    );
  }

  Widget _buildProgressIndicator(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _currentPageIndex == index
                  ? Colors.blue.shade400
                  : Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
