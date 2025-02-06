import 'package:flutter/material.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/settings/presentation/widgets/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleString: 'ME'), body: const SettingsBody(),);
  }
}
