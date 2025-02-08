import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/google_native_signin.dart';
import 'package:wellnest/main.dart';

final _cardColor = primary.withValues(alpha: 150);

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            getSignInBox(context),
            getGoDeluxButton(),
            getSettigsBox(context),
            SizedBox(
                height: 250,
                width: double.infinity,
                child: Lottie.asset('assets/lotties/sleepy-cat.json'))
          ],
        ),
      ),
    );
  }

  Card getSignInBox(BuildContext context) {
    //!adapt it to use the profileProvider, and if profile == null shows the signIn button
    //nah, because of the way it works, you must listen to any change
    final user = supabase.auth.currentUser;

    return Card(
      color: _cardColor,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: user == null
                ? ListTile(
                    trailing: const Icon(
                      Icons.lock,
                      size: 25,
                    ),
                    title: const Text('Google Sign In'),
                    onTap: () async {
                      await googleNativeSignIn();
                      setState(() {});
                    },
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget getGoDeluxButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            icon: const Icon(
              Icons.workspace_premium,
              size: 30,
              color: Colors.white,
            ),
            onClick: () {},
            text: 'GO DELUXE',
            color: secondary.withValues(alpha: 150),
          )),
    );
  }

  Card getSettigsBox(BuildContext context) {
    return Card(
      color: _cardColor,
      child: const SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.star,
                size: 25,
              ),
              title: Text('Rate Us'),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.feedback,
              ),
              title: Text('Feedback'),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.share,
              ),
              title: Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
