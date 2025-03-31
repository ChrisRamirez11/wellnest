import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Size size(BuildContext context) => MediaQuery.sizeOf(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
AppLocalizations localization(BuildContext context) => AppLocalizations.of(context)!;
