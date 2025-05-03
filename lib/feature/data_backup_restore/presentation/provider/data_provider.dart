import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/utils/set_routines_reminders.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/calendar/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/feature/data_backup_restore/business/usecases/get_data_usecase.dart';
import 'package:wellnest/feature/data_backup_restore/business/usecases/update_data_usecase.dart';
import 'package:wellnest/feature/data_backup_restore/data/datasources/data_remote_datasource.dart';
import 'package:wellnest/feature/data_backup_restore/data/models/data_model.dart';
import 'package:wellnest/feature/data_backup_restore/data/repositories/data_repository_impl.dart';
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
          dates[index].completedRoutineAmount +=
              DateModel.fromMap(data!.dates[i]).completedRoutineAmount;
        } else {
          dates.add(DateModel.fromMap(data!.dates[i]));
        }
      }

      //merge the existent with the incoming
      routines
          .addAll(data!.routines.map((e) => RoutineModel.fromMap(e)).toList());
      preferences.backedupData = true;
    }

    //updates the local datas(the backup)
    await ref.watch(routineProvider).upsertAllRoutines(routines);
    await ref.watch(dateProvider).upsertAllDates(dates);

    //updating the providers
    await ref.watch(routineProvider).getRoutines();
    await ref.watch(dateProvider).getDates();

    if (context.mounted) await getRestoreProcess(context, ref);

    //RESTORING NOTIFICATIONS
    NotiService().cancelAllNotifications();
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

Future<void> getRestoreProcess(BuildContext context, WidgetRef ref) async {
  // Get ChangeNotifier instances
  final dateNotifier = ref.read(dateProvider);
  final selectedDateNotifier = ref.read(currentSelectedDateProvider);

  // Update selected date to now
  selectedDateNotifier.changeDate(DateTime.now());

  // Retrieve existing dates and routines
  final allDates = dateNotifier.dates;
  final routines = ref.read(routineProvider).routines ?? [];

  // Check if a model for today already exists
  final exists = allDates?.any((d) =>
          d.date.isAtSameMomentAs(selectedDateNotifier.currentSelectedDate)) ??
      false;

  // No model for today: create one
  if (!exists) {
    await validateDateModel(
        routines, selectedDateNotifier.currentSelectedDate, ref);
    return;
  }

  // Model exists: snapshot current data
  final originalModel = dateNotifier.date!;
  final savedRoutines = List.of(originalModel.routines);
  final savedCompleted = originalModel.completedRoutineAmount;
  final originalId = originalModel.id!;

  // Delete the existing entry
  await dateNotifier.deleteDate(originalId);

  // Re-create a fresh model for today
  await validateDateModel(
      routines, selectedDateNotifier.currentSelectedDate, ref);

  // Merge saved routines and completion count
  final newModel = dateNotifier.date!;
  newModel.routines.removeWhere((r) => savedRoutines.any((s) => s.id == r.id));
  newModel.routines.addAll(savedRoutines);
  newModel.completedRoutineAmount += savedCompleted;

  // Persist merged model
  await dateNotifier.upsertDate(newModel);
}
