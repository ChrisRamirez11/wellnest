import 'package:flutter/material.dart';
import 'package:wellnest/l10n/app_localizations.dart';

Size size(BuildContext context) => MediaQuery.sizeOf(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
AppLocalizations localization(BuildContext context) => AppLocalizations.of(context)!;
