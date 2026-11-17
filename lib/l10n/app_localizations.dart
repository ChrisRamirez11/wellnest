import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @routines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get routines;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @createNewRoutine.
  ///
  /// In en, this message translates to:
  /// **'Create New Routine'**
  String get createNewRoutine;

  /// No description provided for @newRoutine.
  ///
  /// In en, this message translates to:
  /// **'New Routine'**
  String get newRoutine;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @selectWeekDays.
  ///
  /// In en, this message translates to:
  /// **'Select Week Days'**
  String get selectWeekDays;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @routineName.
  ///
  /// In en, this message translates to:
  /// **'Routine name'**
  String get routineName;

  /// No description provided for @deleteReoutineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete this routine?'**
  String get deleteReoutineQuestion;

  /// No description provided for @deleteReoutineAwareness.
  ///
  /// In en, this message translates to:
  /// **'Deleting this routine will simply remove it from your routines list.'**
  String get deleteReoutineAwareness;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'TaskNest is a simple, offline habit tracker. All your routines and progress stay on this device.'**
  String get appDescription;

  /// No description provided for @wakeUpQuestion.
  ///
  /// In en, this message translates to:
  /// **'What time do you usually wake up?'**
  String get wakeUpQuestion;

  /// No description provided for @wakeUpMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose the time you usually start a new day.'**
  String get wakeUpMessage;

  /// No description provided for @sleepQuestion.
  ///
  /// In en, this message translates to:
  /// **'What time do you usually end your day?'**
  String get sleepQuestion;

  /// No description provided for @sleepMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose the time you usually end your day.'**
  String get sleepMessage;

  /// No description provided for @targetQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your target?'**
  String get targetQuestion;

  /// No description provided for @targetMessage.
  ///
  /// In en, this message translates to:
  /// **'Select a category to explore routines.'**
  String get targetMessage;

  /// No description provided for @selectRoutines.
  ///
  /// In en, this message translates to:
  /// **'Select your routines'**
  String get selectRoutines;

  /// No description provided for @selectRoutinesMessage.
  ///
  /// In en, this message translates to:
  /// **'You can always modify your selections later.'**
  String get selectRoutinesMessage;

  /// No description provided for @morningNotiTitle.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get morningNotiTitle;

  /// No description provided for @morningNotiBody.
  ///
  /// In en, this message translates to:
  /// **'Review your daily routines and finish them as you go. Don\'t forget to mark them as done.'**
  String get morningNotiBody;

  /// No description provided for @nightNotiTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey There'**
  String get nightNotiTitle;

  /// No description provided for @nightNotiBody.
  ///
  /// In en, this message translates to:
  /// **'End your day by reviewing unfinished tasks and wrapping them up.'**
  String get nightNotiBody;

  /// No description provided for @morningNoti.
  ///
  /// In en, this message translates to:
  /// **'Morning Notification'**
  String get morningNoti;

  /// No description provided for @nightNoti.
  ///
  /// In en, this message translates to:
  /// **'Night Notification'**
  String get nightNoti;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @timeRoutine.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeRoutine;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get time;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select Duration'**
  String get selectDuration;

  /// No description provided for @selectAmount.
  ///
  /// In en, this message translates to:
  /// **'Select Amount'**
  String get selectAmount;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as Done'**
  String get markDone;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @routineReminderBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to grow, complete your routine'**
  String get routineReminderBody;

  /// No description provided for @quitTimer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to quit the timer?'**
  String get quitTimer;

  /// No description provided for @timerSaved.
  ///
  /// In en, this message translates to:
  /// **'Your current progress will be saved. You can return later to continue.'**
  String get timerSaved;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @remindHabit.
  ///
  /// In en, this message translates to:
  /// **'Remind this habit'**
  String get remindHabit;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @askUnrestrictedBattery.
  ///
  /// In en, this message translates to:
  /// **'To ensure the countdown works properly in the background, allow the app to use Unrestricted Battery.'**
  String get askUnrestrictedBattery;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @endRoutine.
  ///
  /// In en, this message translates to:
  /// **'End Routine'**
  String get endRoutine;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select End Date'**
  String get selectEndDate;

  /// No description provided for @enableNoti.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications permission'**
  String get enableNoti;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health & Fitness'**
  String get health;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity & Focus'**
  String get productivity;

  /// No description provided for @mental_wellness.
  ///
  /// In en, this message translates to:
  /// **'Mental Wellness & Mindfulness'**
  String get mental_wellness;

  /// No description provided for @personal_growth.
  ///
  /// In en, this message translates to:
  /// **'Personal Growth & Learning'**
  String get personal_growth;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization & Lifestyle'**
  String get organization;

  /// No description provided for @long_term_goals.
  ///
  /// In en, this message translates to:
  /// **'Long-Term Goals & Accountability'**
  String get long_term_goals;

  /// No description provided for @drinking_water.
  ///
  /// In en, this message translates to:
  /// **'Drinking more water'**
  String get drinking_water;

  /// No description provided for @daily_exercise.
  ///
  /// In en, this message translates to:
  /// **'Daily exercise (gym, yoga, running)'**
  String get daily_exercise;

  /// No description provided for @stretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching or mobility routines'**
  String get stretching;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Taking medication/vitamins'**
  String get medication;

  /// No description provided for @meal_tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking meals or macros'**
  String get meal_tracking;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro technique sessions'**
  String get pomodoro;

  /// No description provided for @todo_completion.
  ///
  /// In en, this message translates to:
  /// **'Daily to-do list completion'**
  String get todo_completion;

  /// No description provided for @social_media_limit.
  ///
  /// In en, this message translates to:
  /// **'Limiting social media use'**
  String get social_media_limit;

  /// No description provided for @skill_learning.
  ///
  /// In en, this message translates to:
  /// **'Learning a skill (coding, language, etc.)'**
  String get skill_learning;

  /// No description provided for @planning_rituals.
  ///
  /// In en, this message translates to:
  /// **'Morning/evening planning rituals'**
  String get planning_rituals;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation or breathwork'**
  String get meditation;

  /// No description provided for @journaling.
  ///
  /// In en, this message translates to:
  /// **'Journaling (gratitude, reflections)'**
  String get journaling;

  /// No description provided for @therapy.
  ///
  /// In en, this message translates to:
  /// **'Therapy or mood tracking'**
  String get therapy;

  /// No description provided for @digital_detox.
  ///
  /// In en, this message translates to:
  /// **'Digital detox periods'**
  String get digital_detox;

  /// No description provided for @boundaries.
  ///
  /// In en, this message translates to:
  /// **'Setting boundaries (saying no, unplugging)'**
  String get boundaries;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading books/articles'**
  String get reading;

  /// No description provided for @hobby_practice.
  ///
  /// In en, this message translates to:
  /// **'Practicing a hobby (music, art, writing)'**
  String get hobby_practice;

  /// No description provided for @podcasts.
  ///
  /// In en, this message translates to:
  /// **'Listening to podcasts/educational content'**
  String get podcasts;

  /// No description provided for @networking.
  ///
  /// In en, this message translates to:
  /// **'Networking or socializing intentionally'**
  String get networking;

  /// No description provided for @public_speaking.
  ///
  /// In en, this message translates to:
  /// **'Public speaking practice'**
  String get public_speaking;

  /// No description provided for @making_bed.
  ///
  /// In en, this message translates to:
  /// **'Making the bed daily'**
  String get making_bed;

  /// No description provided for @cleaning.
  ///
  /// In en, this message translates to:
  /// **'Weekly cleaning/deep organizing'**
  String get cleaning;

  /// No description provided for @budgeting.
  ///
  /// In en, this message translates to:
  /// **'Budgeting or expense tracking'**
  String get budgeting;

  /// No description provided for @meal_prep.
  ///
  /// In en, this message translates to:
  /// **'Meal prepping'**
  String get meal_prep;

  /// No description provided for @decluttering.
  ///
  /// In en, this message translates to:
  /// **'Decluttering (e.g., 1 item per day)'**
  String get decluttering;

  /// No description provided for @saving_money.
  ///
  /// In en, this message translates to:
  /// **'Saving money (daily/weekly transfers)'**
  String get saving_money;

  /// No description provided for @career_development.
  ///
  /// In en, this message translates to:
  /// **'Career development (courses, networking)'**
  String get career_development;

  /// No description provided for @creative_projects.
  ///
  /// In en, this message translates to:
  /// **'Creative projects (writing, building something)'**
  String get creative_projects;

  /// No description provided for @sustainability.
  ///
  /// In en, this message translates to:
  /// **'Sustainability habits (recycling, reducing waste)'**
  String get sustainability;

  /// No description provided for @relationships.
  ///
  /// In en, this message translates to:
  /// **'Relationship-building (calling family/friends)'**
  String get relationships;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @noRoutines.
  ///
  /// In en, this message translates to:
  /// **'No routines yet'**
  String get noRoutines;

  /// No description provided for @motivationalMessage.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with your first healthy routine. Consistency begins with one small step.'**
  String get motivationalMessage;

  /// No description provided for @apiSeedError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the sample tasks: {error}'**
  String apiSeedError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
