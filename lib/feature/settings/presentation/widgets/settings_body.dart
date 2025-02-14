import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/google_native_signin.dart';
import 'package:wellnest/feature/settings/presentation/widgets/user_signed_button.dart';
import 'package:wellnest/main.dart';

final _cardColor = primary.withAlpha(150);

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

  Widget getSignInBox(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: _cardColor,
      child: user == null
          ? InkWell(
              onTap: () async {
                await googleNativeSignIn();
                if(mounted){
                  setState(() {});
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    minTileHeight: 70,
                    title: Text('Google Sign In'),
                    subtitle: Text('Sign in to sync and backup data'),
                    trailing: Icon(Icons.backup),
                  ),
                ),
              ),
            )
          : const UserSignedButton(),
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
            color: secondary.withAlpha(150),
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
              minTileHeight: 70,
              leading: Icon(
                Icons.star,
                size: 25,
              ),
              title: Text('Rate Us'),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              minTileHeight: 70,
              leading: Icon(
                Icons.feedback,
              ),
              title: Text('Feedback'),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              minTileHeight: 70,
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
