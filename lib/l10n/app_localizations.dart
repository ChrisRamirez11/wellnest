import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja')
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Language ins it´s language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// The calendar appbar title
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// The routines appbar title
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get routines;

  /// The me appbar title
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// Create a new routine button
  ///
  /// In en, this message translates to:
  /// **'Create New Routine'**
  String get createNewRoutine;

  /// New routine appbar title
  ///
  /// In en, this message translates to:
  /// **'New Routine'**
  String get newRoutine;

  /// Contributors title
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributors;

  /// Feedback title
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// About Us title
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about;

  /// Notifications title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Google Sign In title
  ///
  /// In en, this message translates to:
  /// **'Google Sign In'**
  String get signIn;

  /// backupRestoreComment title
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync and backup data'**
  String get backupRestoreComment;

  /// Send button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Feedback or suggestion comment
  ///
  /// In en, this message translates to:
  /// **'Give us feedback or any suggestion.'**
  String get feedbackComment;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Select Week Days
  ///
  /// In en, this message translates to:
  /// **'Select Week Days'**
  String get selectWeekDays;

  /// Select Color
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// Routine name
  ///
  /// In en, this message translates to:
  /// **'Routine name'**
  String get routineName;

  /// Select Language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Go Premium
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goDeluxe;

  /// Premium User
  ///
  /// In en, this message translates to:
  /// **'Premium User'**
  String get premiumUser;

  /// Question in the dialog for deleting routine
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete this routine?'**
  String get deleteReoutineQuestion;

  /// Be aware dialog of deleting routine
  ///
  /// In en, this message translates to:
  /// **'Deleting this routine will simply remove it from your routines list.'**
  String get deleteReoutineAwareness;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Log Out
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// Wellnest explanation for about us
  ///
  /// In en, this message translates to:
  /// **'Wellnest is an app designed to help you manage your wellness and personal growth. Our mission is to provide you with the tools and resources you need to live a healthier, happier life.'**
  String get wellnestWhatIs;

  /// Explanation of our team
  ///
  /// In en, this message translates to:
  /// **'We are a small team trying to give our users the best we can. Your feedback and ideas are the cornerstone of our innovation. By sharing your thoughts, you\'re not just using Wellnest – you\'re helping shape its future.'**
  String get whoWeAre;

  /// Exhort to support with ideas or suggestions
  ///
  /// In en, this message translates to:
  /// **'Have an idea to make Wellnest even better? We\'d love to hear from you! Reach out to us through our in-app suggestion box.'**
  String get supportUsWithIdeas;

  /// Question for onboarding, page 1, select wake up time.
  ///
  /// In en, this message translates to:
  /// **'What time do you usually wake up?'**
  String get wakeUpQuestion;

  /// Message for onboarding, page 1.
  ///
  /// In en, this message translates to:
  /// **'Choose the time you usually start a new day.'**
  String get wakeUpMessage;

  /// Question for onboarding, page 2, select sleep time.
  ///
  /// In en, this message translates to:
  /// **'What time do you usually end your day?'**
  String get sleepQuestion;

  /// Message for onboarding, page 2.
  ///
  /// In en, this message translates to:
  /// **'Choose the time you usually end your day.'**
  String get sleepMessage;

  /// Morning notification greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get morningNotiTitle;

  /// Morning notification body
  ///
  /// In en, this message translates to:
  /// **'Review your daily routines and finish them as you go. Don\'t forget mark them as done'**
  String get morningNotiBody;

  /// Night notification greeting
  ///
  /// In en, this message translates to:
  /// **'Hey There'**
  String get nightNotiTitle;

  /// Night notification body
  ///
  /// In en, this message translates to:
  /// **'End your day by reviewing unfinished tasks and wrapping them up.'**
  String get nightNotiBody;

  /// Morning Notification
  ///
  /// In en, this message translates to:
  /// **'Morning Notification'**
  String get morningNoti;

  /// Night Notification
  ///
  /// In en, this message translates to:
  /// **'Night Notification'**
  String get nightNoti;

  /// Track in create routine
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// Task in create routine
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// Amount in create routine
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// This time is for the RoutineType.time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeRoutine;

  /// To say that a routine of amount is of 1 time
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get time;

  /// To say that a routine of amount is of more or iqual 2 time
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// Select Duration CupertinoPicker
  ///
  /// In en, this message translates to:
  /// **'Select Duration'**
  String get selectDuration;

  /// Select Amount CupertinoPicker
  ///
  /// In en, this message translates to:
  /// **'Select Amount'**
  String get selectAmount;

  /// Today Fab
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Mark as Done
  ///
  /// In en, this message translates to:
  /// **'Mark as Done'**
  String get markDone;

  /// Reset the timer
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Resume
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Pause
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Finish
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// It's time to grow, complete your routine
  ///
  /// In en, this message translates to:
  /// **'It\'s time to grow, complete your routine'**
  String get routineReminderBody;

  /// Quit Timer Question
  ///
  /// In en, this message translates to:
  /// **'Are you sure to quit the timer?'**
  String get quitTimer;

  /// Timer Will be saved message
  ///
  /// In en, this message translates to:
  /// **'Your current progress will be saved. You can return later to continue.'**
  String get timerSaved;

  /// Ok
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Advanced Settings
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// Remind this habit
  ///
  /// In en, this message translates to:
  /// **'Remind this habit'**
  String get remindHabit;

  /// Permission Required
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Ask for unrestricted battery
  ///
  /// In en, this message translates to:
  /// **'To ensure the countdown works properly on the backround, allow the app to use Unrestricted Battery.'**
  String get askUnrestrictedBattery;

  /// Error message shown when the user reaches their monthly token usage limit
  ///
  /// In en, this message translates to:
  /// **'You have reached your token limit.'**
  String get tokenLimitReachedError;

  /// Generic error message shown when the coach response could not be generated
  ///
  /// In en, this message translates to:
  /// **'An error occurred while generating the coach response.'**
  String get coachResponseError;

  /// Next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Message Axio
  ///
  /// In en, this message translates to:
  /// **'Message Axio...'**
  String get messageAxio;

  /// Enable notifications permission
  ///
  /// In en, this message translates to:
  /// **'Enable notifications permission'**
  String get enableNoti;

  /// Go premium to use AxioAI
  ///
  /// In en, this message translates to:
  /// **'Go premium to use AxioAI'**
  String get goPremiumAxio;

  /// Don't Send Data
  ///
  /// In en, this message translates to:
  /// **'Don\'t Send Data'**
  String get dontSendData;

  /// Week Data
  ///
  /// In en, this message translates to:
  /// **'Week Data'**
  String get weekData;

  /// Month Data
  ///
  /// In en, this message translates to:
  /// **'Month Data'**
  String get monthData;

  /// Title of the token usage dialog
  ///
  /// In en, this message translates to:
  /// **'Token usage'**
  String get tokenUsageTitle;

  /// Displays input token usage with used and limit values
  ///
  /// In en, this message translates to:
  /// **'Input tokens'**
  String get tokenUsageInput;

  /// Displays output token usage with used and limit values
  ///
  /// In en, this message translates to:
  /// **'Output tokens'**
  String get tokenUsageOutput;

  /// Title of the token usage explanation section
  ///
  /// In en, this message translates to:
  /// **'How Token Usage Works'**
  String get tokenUsageTitleExplanation;

  /// Explanation of how token usage works
  ///
  /// In en, this message translates to:
  /// **'Every time you send a message to Axio or receive a response, tokens are used. They represent the effort it takes to process your input and generate meaningful replies.\n\nThese limits help keep your experience focused and intentional. If either limit is reached, coaching will pause until the next monthly cycle begins.\n\n\"Tokens aren\'t money or points. They\'re how much I can think, and how much you can ask.\"\n— Axio'**
  String get tokenUsageExplanation;

  /// Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
