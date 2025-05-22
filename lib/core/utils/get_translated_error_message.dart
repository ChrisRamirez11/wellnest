import 'package:flutter/material.dart';
import 'package:wellnest/l10n/app_localizations.dart';

String getTranslatedErrorMessage(String errorString, BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  switch (errorString) {
    case 'premium_required':
      return loc.premiumRequired;
    case 'plan_expired':
      return loc.limitReached;
    default:
      return loc.genericError;
  }
}
