import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/utils/show_paywall.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/first_app_opening.dart';
import 'package:wellnest/feature/onboarding/presentation/widgets/onboarding_page_one.dart';
import 'package:wellnest/feature/onboarding/presentation/widgets/onboarding_page_two.dart';

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

  final List<Widget> _pages = [OnboardingPageOne(), OnboardingPageTwo()];

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
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        actions: [
          SizedBox(
            width: 50,
          )
        ],
        centerTitle: true,
        title: _buildProgressIndicator(),
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
      bottomNavigationBar: getButtons(context),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }

  Padding getButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: _currentPageIndex != (_pages.length - 1)
          ? CustomButton(
              color: colorScheme(context).primaryContainer,
              textColor: ghostWhite,
              onClick: () {
                _controller.nextPage(
                  duration: Duration(milliseconds: _pageChangeSpeed),
                  curve: Curves.easeIn,
                );
              },
              text: 'NEXT')//TODO intl
          : CustomButton(
              color: colorScheme(context).primaryContainer,
              textColor: ghostWhite,
              onClick: () {
                // when FINISH is hitted, is when it understands the first step of the app was succesful
                ref.watch(firstTimeOpening).appOpened();
                showPaywall();

                Navigator.of(context).pushReplacementNamed('/');
              },
              text: localization(context).finish.toUpperCase()),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _currentPageIndex == index
                  ? primary
                  : Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
