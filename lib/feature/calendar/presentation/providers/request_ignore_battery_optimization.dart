import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/utils/utils.dart';

Future<void> requestIgnoreBatteryOptimizations(BuildContext context) async {
  final prefs = UserPreferences();

  if (Platform.isAndroid || Platform.isIOS) {
    final isIgnoring = await Permission.ignoreBatteryOptimizations.isLimited;

    if (!isIgnoring) {
      final status = await Permission.ignoreBatteryOptimizations.request();

      if (!status.isGranted && context.mounted) {
        // Show undismissible dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                localization(context).permissionRequired,
                style: textTheme(context).bodyLarge,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    localization(context).askUnrestrictedBattery,
                    style: textTheme(context).labelMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings(); // Redirect to app settings
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        localization(context).ok,
                        style: textTheme(context).bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        prefs.batteryPermissionAsked = true;
      }
    } else {
      debugPrint('The app already ignores battery optimizations');
    }
  }
}
