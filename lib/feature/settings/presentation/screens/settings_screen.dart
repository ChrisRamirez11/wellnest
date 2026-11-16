import 'package:flutter/material.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/core/widgets/custom_app_bar.dart';
import 'package:task_nest/feature/settings/presentation/widgets/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleString: localization(context).settings.toUpperCase(),
      ),
      body: const SettingsBody(),
    );
  }
}
