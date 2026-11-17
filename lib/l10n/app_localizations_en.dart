// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get calendar => 'Calendar';

  @override
  String get routines => 'Routines';

  @override
  String get settings => 'Settings';

  @override
  String get createNewRoutine => 'Create New Routine';

  @override
  String get newRoutine => 'New Routine';

  @override
  String get about => 'About';

  @override
  String get notifications => 'Notifications';

  @override
  String get save => 'Save';

  @override
  String get selectWeekDays => 'Select Week Days';

  @override
  String get selectColor => 'Select Color';

  @override
  String get routineName => 'Routine name';

  @override
  String get deleteReoutineQuestion => 'Are you sure to delete this routine?';

  @override
  String get deleteReoutineAwareness =>
      'Deleting this routine will simply remove it from your routines list.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get appDescription =>
      'TaskNest is a simple, offline habit tracker. All your routines and progress stay on this device.';

  @override
  String get wakeUpQuestion => 'What time do you usually wake up?';

  @override
  String get wakeUpMessage => 'Choose the time you usually start a new day.';

  @override
  String get sleepQuestion => 'What time do you usually end your day?';

  @override
  String get sleepMessage => 'Choose the time you usually end your day.';

  @override
  String get targetQuestion => 'What\'s your target?';

  @override
  String get targetMessage => 'Select a category to explore routines.';

  @override
  String get selectRoutines => 'Select your routines';

  @override
  String get selectRoutinesMessage =>
      'You can always modify your selections later.';

  @override
  String get morningNotiTitle => 'Good Morning';

  @override
  String get morningNotiBody =>
      'Review your daily routines and finish them as you go. Don\'t forget to mark them as done.';

  @override
  String get nightNotiTitle => 'Hey There';

  @override
  String get nightNotiBody =>
      'End your day by reviewing unfinished tasks and wrapping them up.';

  @override
  String get morningNoti => 'Morning Notification';

  @override
  String get nightNoti => 'Night Notification';

  @override
  String get track => 'Track';

  @override
  String get task => 'Task';

  @override
  String get amount => 'Amount';

  @override
  String get timeRoutine => 'Time';

  @override
  String get time => 'time';

  @override
  String get times => 'times';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectAmount => 'Select Amount';

  @override
  String get today => 'Today';

  @override
  String get markDone => 'Mark as Done';

  @override
  String get reset => 'Reset';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get finish => 'Finish';

  @override
  String get routineReminderBody => 'It\'s time to grow, complete your routine';

  @override
  String get quitTimer => 'Are you sure to quit the timer?';

  @override
  String get timerSaved =>
      'Your current progress will be saved. You can return later to continue.';

  @override
  String get ok => 'Ok';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get remindHabit => 'Remind this habit';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get askUnrestrictedBattery =>
      'To ensure the countdown works properly in the background, allow the app to use Unrestricted Battery.';

  @override
  String get next => 'Next';

  @override
  String get endRoutine => 'End Routine';

  @override
  String get selectEndDate => 'Select End Date';

  @override
  String get enableNoti => 'Enable notifications permission';

  @override
  String get health => 'Health & Fitness';

  @override
  String get productivity => 'Productivity & Focus';

  @override
  String get mental_wellness => 'Mental Wellness & Mindfulness';

  @override
  String get personal_growth => 'Personal Growth & Learning';

  @override
  String get organization => 'Organization & Lifestyle';

  @override
  String get long_term_goals => 'Long-Term Goals & Accountability';

  @override
  String get drinking_water => 'Drinking more water';

  @override
  String get daily_exercise => 'Daily exercise (gym, yoga, running)';

  @override
  String get stretching => 'Stretching or mobility routines';

  @override
  String get medication => 'Taking medication/vitamins';

  @override
  String get meal_tracking => 'Tracking meals or macros';

  @override
  String get pomodoro => 'Pomodoro technique sessions';

  @override
  String get todo_completion => 'Daily to-do list completion';

  @override
  String get social_media_limit => 'Limiting social media use';

  @override
  String get skill_learning => 'Learning a skill (coding, language, etc.)';

  @override
  String get planning_rituals => 'Morning/evening planning rituals';

  @override
  String get meditation => 'Meditation or breathwork';

  @override
  String get journaling => 'Journaling (gratitude, reflections)';

  @override
  String get therapy => 'Therapy or mood tracking';

  @override
  String get digital_detox => 'Digital detox periods';

  @override
  String get boundaries => 'Setting boundaries (saying no, unplugging)';

  @override
  String get reading => 'Reading books/articles';

  @override
  String get hobby_practice => 'Practicing a hobby (music, art, writing)';

  @override
  String get podcasts => 'Listening to podcasts/educational content';

  @override
  String get networking => 'Networking or socializing intentionally';

  @override
  String get public_speaking => 'Public speaking practice';

  @override
  String get making_bed => 'Making the bed daily';

  @override
  String get cleaning => 'Weekly cleaning/deep organizing';

  @override
  String get budgeting => 'Budgeting or expense tracking';

  @override
  String get meal_prep => 'Meal prepping';

  @override
  String get decluttering => 'Decluttering (e.g., 1 item per day)';

  @override
  String get saving_money => 'Saving money (daily/weekly transfers)';

  @override
  String get career_development => 'Career development (courses, networking)';

  @override
  String get creative_projects =>
      'Creative projects (writing, building something)';

  @override
  String get sustainability =>
      'Sustainability habits (recycling, reducing waste)';

  @override
  String get relationships => 'Relationship-building (calling family/friends)';

  @override
  String get ended => 'Ended';

  @override
  String get noRoutines => 'No routines yet';

  @override
  String get motivationalMessage =>
      'Start your journey with your first healthy routine. Consistency begins with one small step.';

  @override
  String apiSeedError(String error) {
    return 'Could not load the sample tasks: $error';
  }
}
