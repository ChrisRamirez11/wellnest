import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/utils/are_same_routine.dart';
import 'package:wellnest/core/utils/set_routines_reminders.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/calendar/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/feature/data_backup_restore/business/usecases/get_data_usecase.dart';
import 'package:wellnest/feature/data_backup_restore/business/usecases/update_data_usecase.dart';
import 'package:wellnest/feature/data_backup_restore/data/datasources/data_remote_datasource.dart';
import 'package:wellnest/feature/data_backup_restore/data/models/data_model.dart';
import 'package:wellnest/feature/data_backup_restore/data/repositories/data_repository_impl.dart';
import 'package:wellnest/feature/data_backup_restore/presentation/provider/was_created_before.dart';
import 'package:wellnest/feature/dates/business/usecases/get_every_date.dart';
import 'package:wellnest/feature/dates/data/datasources/local/date_local_datasource.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/data/repositories/date_repository_impl.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/routines/business/usecases/get_every_routine.dart';
import 'package:wellnest/feature/routines/data/datasources/local/routine_local_datasource.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/routines/data/repositories/routine_repository_impl.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/main.dart';

final dataProvider = ChangeNotifierProvider(
  (ref) => DataProvider(),
);

class DataProvider extends ChangeNotifier {
  bool loading = false;
  Failure? _failure;

  get failure => _failure;

  //Setting Up the repositories
  //Backup and Restore - Data Repository
  final _dataRepository =
      DataRepositoryImpl(dataRemoteDatasource: DataRemoteDatasourceImpl());
  //local data to be restored
  final _dateRepository =
      DateRepositoryImpl(dateLocalDatasource: DateLocalDatasourceImpl());
  final _routineRepository = RoutineRepositoryImpl(
      routineLocalDatasource: RoutineLocalDatasourceImpl());

  Future<void> backupRestore(WidgetRef ref, BuildContext context) async {
    final userId = supabase.auth.currentUser!.id;
    final preferences = UserPreferences();

    //setting up the ChangeNotifiers
    final routinesNotifier = ref.watch(routineProvider);
    final dateNotifier = ref.watch(dateProvider);

    //set up the backup and restore UseCases
    final getDataUseCase =
        GetDataUsecase(dataRepository: _dataRepository); //backup
    final updateDataUseCase =
        UpdateDataUsecase(dataRepository: _dataRepository); //restore

    //fetch the local datas
    final datesOrFailure = await GetEveryDate(_dateRepository).call();
    final routinesOrFailure = await GetEveryRoutine(_routineRepository).call();

    //variables to save the local data
    List<DateModel> dates = [];
    List<RoutineModel> routines = [];

    //data variable
    DataModel? data;

    //methods
    //sees if theres a failure in getting any local data or saves it if not
    datesOrFailure.fold(
      (l) => _failure = l,
      (r) => dates = r
          .map(
            (e) => DateModel.fromEntity(e),
          )
          .toList(),
    );

    routinesOrFailure.fold(
      (l) => _failure = l,
      (r) => routines = r
          .map(
            (e) => RoutineModel.fromEntity(e),
          )
          .toList(),
    );

    //failure != null stops function
    if (_failure != null) {
      if (context.mounted) {
        didFail(context);
      }
      return;
    }

    //fetch data or failure
    final dataOrFailure = await getDataUseCase.call();
    dataOrFailure.fold(
      (l) => _failure = l,
      (r) => data = DataModel.fromEntity(r),
    );

    //failure != null stops function
    if (_failure != null) {
      if (context.mounted) {
        didFail(context);
      }
      return;
    }

    //if data not null will add the fetched data to local datas(eg. List<DateModel>)
    //GOOD TO KNOW that here is were really is backing up by adding data to the local
    if (data != null && !preferences.backedupData) {
      for (var i = 0; i < data!.dates.length; i++) {
        if (dates.any((element) => //we check if the date exists
            element.date == DateModel.fromMap(data!.dates[i]).date)) {
          //we take the index of the existent date
          final index = dates.indexWhere((element) =>
              element.date == DateModel.fromMap(data!.dates[i]).date);
          //merge the existent with the incoming
          dates[index]
              .routines
              .addAll(DateModel.fromMap(data!.dates[i]).routines);
          dates[index].completedRoutineAmount =
              _getCompletedQuantity(DateModel.fromMap(data!.dates[i]));
        } else {
          dates.add(DateModel.fromMap(data!.dates[i]));
        }
      }

      //merge the existent with the incoming
      routines
          .addAll(data!.routines.map((e) => RoutineModel.fromMap(e)).toList());
    }

    //updates the local datas(the backup)
    await routinesNotifier
        .upsertAllRoutines(routines); //routines first so they have an id
    await dateNotifier.upsertAllDates(dates);

    //updating the providers
    await routinesNotifier.getRoutines();
    await dateNotifier.getDates();

    if (context.mounted && !preferences.backedupData) {
      //if is backing up we set the backedupData to true so it wont create a restore point
      preferences.backedupData = true;
      //this is used to maerge today date with saved data
      await getRestoreProcess(
          ref,
          data!.dates
              .map(
                (e) => DateModel.fromMap(e),
              )
              .toList());
    }

    //RESTORING NOTIFICATIONS // this most be done only once
    await NotiService().cancelAllNotifications();
    if (context.mounted) await setGlobalAppNotification(ref, context);
    if (context.mounted) await setRoutinesReminders(context, ref);

    //UPDATES data to how it should depending on if is backing up or just creating the restore point
    data = DataModel(
        id: data!.id,
        userId: userId,
        dates: ref
            .watch(dateProvider)
            .dates!
            .map(
              (e) => e.toMap(),
            )
            .toList(),
        routines: ref
            .watch(routineProvider)
            .routines!
            .map(
              (e) => e.toMap(),
            )
            .toList());
    //creates the restore point
    final voidOrFailure = await updateDataUseCase.call(data!);

    voidOrFailure.fold(
      (l) => _failure = l,
      (r) => debugPrint('Data Update Succesful'),
    );

    //failure != null stops function
    if (_failure != null) {
      if (context.mounted) {
        didFail(context);
      }
      return;
    }

    notifyListeners();
    debugPrint('Backup and Restore Succesful');
  }

  setLoadingTrue() {
    loading = true;
    notifyListeners();
  }

  void didFail(BuildContext context) {
    loading = false;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(_failure!.errorMessage)));
    notifyListeners();
    return;
  }
}

Future<void> getRestoreProcess(WidgetRef ref, List<DateModel> dates) async {
  // Get ChangeNotifier instances
  final dateNotifier = ref.watch(dateProvider);
  final selDateN = ref.watch(currentSelectedDateProvider);
  final routines = ref.watch(routineProvider).routines ?? [];
  List<Routine> preservedRoutinesFromDate =
      []; // List to store preserved routines before backupRestore (Most Have IDs)
  List<Routine> routinesListWithID = []; // List to store routines with IDs

  final wasCreatedBeforeNotifier = ref.watch(todayDateCreatedBefore);

  // Update selected date to now
  selDateN.changeDate(DateTime.now());

  await validateDateModel(routines, selDateN.currentSelectedDate, ref);

  if (dateNotifier.date?.id != null) {
    //if have ID date exists before backupRestore
    preservedRoutinesFromDate.addAll(dateNotifier.date!.routines);
    await dateNotifier.deleteDate(dateNotifier.date!.id!);
    wasCreatedBeforeNotifier.setValue(true);
  } else {
    return;
  }

  // Re-create a fresh model for today
  await validateDateModel(routines, selDateN.currentSelectedDate, ref);

  if (preservedRoutinesFromDate.isNotEmpty) {
    dateNotifier.date!.routines.removeWhere(
      //performed to preserve the state of the routines befoe backupRestore
      (r) => preservedRoutinesFromDate.any(
        (preserved) => r.id == preserved.id,
      ),
    );
  }

  log(dateNotifier.date!.routines
      .map(
        (e) => e.id,
      )
      .toList()
      .toString());
  log('-----------------');

  bool dataFromServer =
      dates.any((element) => element.date == selDateN.currentSelectedDate);

  log('dataFromServer is: $dataFromServer');

  // var list = (wasCreatedBeforeNotifier.was && dataFromServer) ? :

  for (var routine in routines) {
    final routineIndex = dateNotifier.date!.routines.indexWhere(
      (r) => areSameRoutine(r.toModel(), routine),
    );

    if (routineIndex != -1) {
      final id = routine.id;
      Routine routineWithNoId = (dataFromServer
              ? dates
                  .where(
                      (element) => element.date == selDateN.currentSelectedDate)
                  .first
                  .routines
              : dateNotifier.date!.routines)
          .where((element) => areSameRoutine(element.toModel(), routine))
          .first;

      // Merge properties except for the id that is in the routine from the date
      routinesListWithID.add(Routine(
          id: id,
          name: routineWithNoId.name,
          days: routineWithNoId.days,
          finished: routineWithNoId.finished,
          createdDate: routineWithNoId.createdDate,
          colorValue: routineWithNoId.colorValue,
          type: routineWithNoId.type,
          targetCount: routineWithNoId.targetCount,
          currentCount: routineWithNoId.currentCount,
          targetDurationSeconds: routineWithNoId.targetDurationSeconds,
          elapsedTimeSeconds: routineWithNoId.elapsedTimeSeconds,
          alarmActive: routineWithNoId.alarmActive ?? false,
          alarmTime: routineWithNoId.alarmTime,
          endAt: routineWithNoId.endAt));
    }
  }

  if (wasCreatedBeforeNotifier.was) {
    preservedRoutinesFromDate.removeWhere(
      (r) => routinesListWithID.any(
        (element) => areSameRoutine(r.toModel(), element.toModel()),
      ),
    );
  }

  log('${preservedRoutinesFromDate.map(
    (e) => e.id,
  )} preservedRoutinesFromDate');
  log('${preservedRoutinesFromDate.map(
    (e) => e.name,
  )} preservedRoutinesFromDate');

  log('-----------------------');

  log('${routinesListWithID.map(
    (e) => e.id,
  )} routinesListWithID');
  log('${routinesListWithID.map(
    (e) => e.name,
  )} routinesListWithID');

  dateNotifier.date!.routines = []; // Clear the existing routines list
  dateNotifier.date!.routines //Add the preserved routines and the new ones
      .addAll([...preservedRoutinesFromDate, ...routinesListWithID]);
  dateNotifier.date!.completedRoutineAmount =
      _getCompletedQuantity(dateNotifier.date!);

  // Persist merged model
  await dateNotifier.upsertDate(dateNotifier.date!);
}

int _getCompletedQuantity(DateModel dateModel) {
  int result = 0;
  for (var routine in dateModel.routines) {
    result += routine.finished! ? 1 : 0;
  }
  return result;
}
