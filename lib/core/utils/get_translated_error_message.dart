import 'package:flutter/material.dart';
import 'package:wellnest/l10n/app_localizations.dart';

String getTranslatedErrorMessage(
    {required String errorString,
    String? unstranslated,
    required BuildContext context}) {
  final loc = AppLocalizations.of(context)!;

  switch (errorString) {
    case 'coach_response_error':
      return loc.coachResponseError;
    case 'token_limit':
      return loc.tokenLimitReachedError;
    default:
      return errorString;
  }
}
