import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/core/shared_preferences/user_preferences.dart';
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

  Future<void> backupRestore(WidgetRef ref) async {
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
      loading = false;
      notifyListeners();
      return;
    }

    //fetch data or failure
    final dataOrFailure = await getDataUseCase.call();
    dataOrFailure.fold(
      (l) => _failure,
      (r) => data = DataModel.fromEntity(r),
    );

    //failure != null stops function
    if (_failure != null) {
      loading = false;
      notifyListeners();
      return;
    }

    //if data not null will add the fetched data to local datas(eg. List<DateModel>)
    //GOOD TO KNOW that here is were really is backing up by adding data to the local
    //! To avoid recovering deleted data, the back up just happens once, from there evrey time it will create the restore point
    //! so if you uninstall the app is when will only need to back it up.
    if (data != null && !preferences.backedupData) {
      for (var i = 0; i < data!.dates.length; i++) {
        if(dates.any((element) => element.date == DateModel.fromMap(data!.dates[i]).date)){//we check if the date exists
          //we tak the index of the existent date
          final index = dates.indexWhere((element) => element.date == DateModel.fromMap(data!.dates[i]).date);
          //merge the existent with the incoming
          dates[index].routines.addAll(DateModel.fromMap(data!.dates[i]).routines);
          dates[index].completedRoutineAmount += DateModel.fromMap(data!.dates[i]).completedRoutineAmount;
        }else{
          dates.add(DateModel.fromMap(data!.dates[i]));
        }
      }

      routines
          .addAll(data!.routines.map((e) => RoutineModel.fromMap(e)).toList());
      preferences.backedupData = true;
    }

    //updates data to how it should if is backing up or just creating the restore point
    data = DataModel(
        id: data!.id,
        userId: userId,
        dates: dates
            .map(
              (e) => e.toMap(),
            )
            .toList(),
        routines: routines
            .map(
              (e) => e.toMap(),
            )
            .toList());

    //creates the restore point
    final voidOrFailure = await updateDataUseCase.call(data!);

    voidOrFailure.fold(
      (l) => _failure = failure,
      (r) => debugPrint('Data Update Succesful'),
    );

    //updates the local datas(the backup)
    final routinesUpdatedOrFailure =
        await _routineRepository.upsertAllRoutines(routines
            .map(
              (e) => e.toEntity(),
            )
            .toList());

    routinesUpdatedOrFailure.fold(
      (l) => _failure = l,
      (r) => debugPrint('routines backup succesful'),
    );

    final datesUpdatedOrFailure = await _dateRepository.upsertAllDates(dates
        .map(
          (e) => e.toEntity(),
        )
        .toList());

    datesUpdatedOrFailure.fold(
      (l) => _failure = l,
      (r) => debugPrint('dates backup succesful'),
    );

    //updating the providers
    await ref.watch(dateProvider).getDates();
    await ref.watch(routineProvider).getRoutines();

    notifyListeners();
    debugPrint('Backup and Restore Succesful');
  }

  setLoadingTrue() {
    loading = true;
    notifyListeners();
  }
}
