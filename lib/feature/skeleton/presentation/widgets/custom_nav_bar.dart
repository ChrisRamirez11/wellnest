import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:wellnest/core/navigation/custom_transitions.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/feature/ai_coach/presentation/screens/coach_chat_screen.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/google_native_signin.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/profile_provider.dart';
import 'package:wellnest/feature/skeleton/presentation/providers/index_provider.dart';
import 'package:wellnest/feature/skeleton/presentation/widgets/axio_widget.dart';
import 'package:wellnest/feature/skeleton/presentation/widgets/bottom_nav_tab.dart';
import 'package:wellnest/main.dart';

class CustomNavBar extends ConsumerStatefulWidget {
  final PageController pageController;

  const CustomNavBar({super.key, required this.pageController});

  @override
  ConsumerState<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends ConsumerState<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);

    return SizedBox(
      height: 70,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: obsidian,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomNavTab(
                  pageIndex: 0,
                  isSelected: index.selectedIndex == 0,
                  iconFilled: Icons.calendar_month,
                  iconOutlined: Icons.calendar_month_outlined,
                  pageController: widget.pageController,
                ),
                const SizedBox(width: 10),
                BottomNavTab(
                  pageIndex: 1,
                  isSelected: index.selectedIndex == 1,
                  iconFilled: Icons.person,
                  iconOutlined: Icons.person_outline,
                  pageController: widget.pageController,
                ),
              ],
            ),
          ),

          // Central floating button
          Positioned(
            bottom: 5,
            top: 5,
            child: GestureDetector(
                onTap: () => getSignInOrAxioScreen(context),
                child: Container(
                  height: 60,
                  width: 75,
                  decoration: BoxDecoration(
                    color: obsidian,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: AxioWidget(),
                )),
          ),
        ],
      ),
    );
  }

  void getSignInOrAxioScreen(BuildContext context) async {
    var user = supabase.auth.currentUser;
    var profileNotifier = ref.watch(profileProvider);
    if (user == null && profileNotifier.profile == null) {
      await googleNativeSignIn();
      if (mounted) {
        setState(() {
          user = supabase.auth.currentUser;
        });
        await profileNotifier.getMyUserData();
      }
    }
    if (user == null && profileNotifier.profile == null) return;
    await axioPatternVibrate();
    if (context.mounted) {
      await Navigator.of(context).push(slideFromBottomRoute(CoachChatScreen()));
    }
  }
}

Future<void> axioPatternVibrate() async {
  final result = await Vibration.hasVibrator();
  if (result) {
    Vibration.vibrate(
      pattern: [40, 70, 90, 40, 70, 10],
      intensities: [0, 35, 0, 35, 0],
    );
  } else {
    Vibration.vibrate(duration: 100);
  }
}
