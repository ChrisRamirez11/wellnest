import 'package:flutter/material.dart';
import 'package:task_nest/l10n/app_localizations.dart';

Size size(BuildContext context) => MediaQuery.sizeOf(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
AppLocalizations localization(BuildContext context) =>
    AppLocalizations.of(context)!;
