import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

final _cardColor = primary.withValues(alpha: 150);

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

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
    return Card(
      color: _cardColor,
      child: const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ListTile(
              trailing: Icon(
                Icons.lock,
                size: 25,
              ),
              title: Text('Google Sign In'),
            ),
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
