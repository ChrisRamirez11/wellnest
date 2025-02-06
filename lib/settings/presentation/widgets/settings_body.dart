import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/settings/presentation/widgets/dark_mode_button.dart';

final _cardColor = primary.withValues(alpha: 150);

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        children: [
          getSignInBox(context),
          getGoDeluxButton(),
          getSettigsBox(context)
        ],
      ),
    );
  }

  Widget getGoDeluxButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            icon: Icon(
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

  Card getSignInBox(BuildContext context) {
    return Card(
      color: _cardColor,
      child: SizedBox(
        width: double.infinity,
        height: size(context).height * 0.1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ListTile(
              trailing: const Icon(
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

  Card getSettigsBox(BuildContext context) {
    return Card(
      color: _cardColor,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            DarkModeButton(),
            Divider(),
            ListTile(
              leading: const Icon(
                Icons.feedback,
              ),
              title: Text('Feedback'),
            ),
            Divider(),
            ListTile(
              leading: const Icon(
                Icons.share,
              ),
              title: Text('Sahre'),
            ),
          ],
        ),
      ),
    );
  }
}
