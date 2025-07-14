import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/errors/failures.dart';
import 'package:wellnest/core/notifications/global_app_notification.dart';
import 'package:wellnest/core/notifications/noti_service.dart';
import 'package:wellnest/core/preferences/user_preferences.dart';
import 'package:wellnest/core/utils/are_same_routine.dart';
import 'package:wellnest/core/utils/set_routines_reminders.dart';
import 'package:wellnest/core/utils/utils.dart';
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

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class DataProvider extends ChangeNotifier {
  bool loading = false;
  Failure? _failure;
  Failure? get failure => _failure;

  final _dataRepo =
      DataRepositoryImpl(dataRemoteDatasource: DataRemoteDatasourceImpl());
  final _dateRepo =
      DateRepositoryImpl(dateLocalDatasource: DateLocalDatasourceImpl());
  final _routineRepo = RoutineRepositoryImpl(
      routineLocalDatasource: RoutineLocalDatasourceImpl());

  void clearFailure() {
    _failure = null;
  }

  Future<void> backupRestore(WidgetRef ref, BuildContext context) async {
    loading = true;
    notifyListeners();

    final userId = supabase.auth.currentUser!.id;
    final prefs = UserPreferences();
    final routinesNotifier = ref.read(routineProvider);
    final datesNotifier = ref.read(dateProvider);

    // Fetch local data
    final datesResult = await GetEveryDate(_dateRepo).call();
    final routinesResult = await GetEveryRoutine(_routineRepo).call();

    List<DateModel> localDates = [];
    List<RoutineModel> localRoutines = [];

    datesResult.fold(
      (err) => _failure = err,
      (list) => localDates = list.map(DateModel.fromEntity).toList(),
    );
    routinesResult.fold(
      (err) => _failure = err,
      (list) => localRoutines = list.map(RoutineModel.fromEntity).toList(),
    );

    if (context.mounted && _handleFailure(context)) return;

    // Fetch remote backup
    final dataResult = await GetDataUsecase(dataRepository: _dataRepo).call();
    DataModel? remoteData;
    dataResult.fold(
      (err) => _failure = err,
      (entity) => remoteData = DataModel.fromEntity(entity),
    );
    if (context.mounted && _handleFailure(context)) return;

    // Merge remote into local on first backup
    if (remoteData != null && !prefs.backedupData) {
      _mergeDates(localDates, remoteData!.dates);
      localRoutines.addAll(remoteData!.routines.map(RoutineModel.fromMap));
    }

    // Persist merged local data
    await routinesNotifier.upsertAllRoutines(localRoutines);
    await datesNotifier.upsertAllDates(localDates);
    await routinesNotifier.getRoutines();
    await datesNotifier.getDates();

    // Create restore point if first backup
    if (!prefs.backedupData && remoteData != null) {
      prefs.backedupData = true;
      await _createRestorePoint(
          ref, remoteData!.dates.map(DateModel.fromMap).toList());
    }

    // Reset notifications
    await NotiService().cancelAllNotifications();
    if (context.mounted) {
      await setGlobalAppNotification(ref, context);
      if (context.mounted) await setRoutinesReminders(context, ref);
    }

    // Update remote with current state
    final updatedData = DataModel(
      id: remoteData!.id,
      userId: userId,
      dates: ref.read(dateProvider).dates!.map((e) => e.toMap()).toList(),
      routines:
          ref.read(routineProvider).routines!.map((e) => e.toMap()).toList(),
    );
    final updateResult =
        await UpdateDataUsecase(dataRepository: _dataRepo).call(updatedData);
    updateResult.fold(
        (err) => _failure = err, (_) => debugPrint('Data update successful'));
    if (context.mounted && _handleFailure(context)) return;

    loading = false;
    notifyListeners();
    debugPrint('Backup and restore completed');
  }

  bool _handleFailure(BuildContext context) {
    if (_failure != null) {
      loading = false;
      if (context.mounted) _showError(context);
      notifyListeners();
      return true;
    }
    return false;
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_failure!.errorMessage,
              style: textTheme(context).labelMedium)),
    );
  }

  void _mergeDates(List<DateModel> local, List<Map<String, dynamic>> remote) {
    for (final raw in remote) {
      final incoming = DateModel.fromMap(raw);
      final idx = local.indexWhere((d) => d.date == incoming.date);
      if (idx >= 0) {
        local[idx].routines.addAll(incoming.routines);
        local[idx].completedRoutineAmount = _countCompleted(local[idx]);
      } else {
        local.add(incoming);
      }
    }
  }

  Future<void> _createRestorePoint(
    WidgetRef ref,
    List<DateModel> backupDates,
  ) async {
    final dateNotifier = ref.read(dateProvider);
    final selDateN = ref.read(currentSelectedDateProvider);
    final wasBefore = ref.read(todayDateCreatedBefore);
    final routines = ref.read(routineProvider).routines!;

    // 1. Move selected date to today and ensure it exists
    selDateN.changeDate(DateTime.now());
    await validateDateModel(routines, selDateN.currentSelectedDate, ref);

    // 2. If today's date existed, preserve its routines and delete it
    List<Routine> preserved = [];
    if (dateNotifier.date?.id != null) {
      preserved = List.from(dateNotifier.date!.routines);
      await dateNotifier.deleteDate(dateNotifier.date!.id!);
      wasBefore.setValue(true);
    } else {
      // If no existing date, nothing to restore
      return;
    }

    // 3. Re-create today’s date (fresh, empty)
    await validateDateModel(routines, selDateN.currentSelectedDate, ref);

    // 4. Remove from the new date any routines we already preserved
    if (preserved.isNotEmpty) {
      dateNotifier.date!.routines
          .removeWhere((r) => preserved.any((p) => p.id == r.id));
    }

    // 5. Decide source list: server backup vs local date
    final dataFromServer =
        backupDates.any((d) => d.date == selDateN.currentSelectedDate);
    final sourceDate = dataFromServer
        ? backupDates.firstWhere((d) => d.date == selDateN.currentSelectedDate)
        : dateNotifier.date!;
    final sourceRoutines = sourceDate.routines;

    // 6. Merge back into a list with preserved IDs
    final merged = <Routine>[];
    for (final orig in routines) {
      // find if this routine exists in the new date
      final matchIdx = dateNotifier.date!.routines
          .indexWhere((d) => areSameRoutine(d.toModel(), orig));
      if (matchIdx != -1) {
        // pick the matching routine from the correct source
        final template = sourceRoutines.firstWhere(
          (d) => areSameRoutine(d.toModel(), orig),
          orElse: () => dateNotifier.date!.routines[matchIdx],
        );

        // recreate with original ID but updated properties
        merged.add(Routine(
          id: orig.id,
          name: template.name,
          days: template.days,
          finished: template.finished,
          createdDate: template.createdDate,
          colorValue: template.colorValue,
          type: template.type,
          targetCount: template.targetCount,
          currentCount: template.currentCount,
          targetDurationSeconds: template.targetDurationSeconds,
          elapsedTimeSeconds: template.elapsedTimeSeconds,
          alarmActive: template.alarmActive ?? false,
          alarmTime: template.alarmTime,
          endAt: template.endAt,
        ));
      } else {
        // not in date’s routines → skip or log
        debugPrint('⚠️ Routine not matched: ${orig.name} (${orig.id})');
      }
    }

    // 7. If we preserved an old date, drop duplicates and combine
    if (wasBefore.was) {
      preserved.removeWhere(
          (p) => merged.any((m) => areSameRoutine(p.toModel(), m.toModel())));
    }
    dateNotifier.date!
      ..routines = [...preserved, ...merged]
      ..completedRoutineAmount = _countCompleted(dateNotifier.date!);

    // 8. Persist the merged date
    await dateNotifier.upsertDate(dateNotifier.date!);
  }

  int _countCompleted(DateModel date) =>
      date.routines.where((r) => r.finished == true).length;
}
