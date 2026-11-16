import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/ai_coach/data/models/day_info_model.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/period_data_provider/all_dates_provider.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/period_data_provider/period_data_state.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_text_box.dart';

final periodDataNotifierProvider =
    StateNotifierProvider<PeriodDataNotifier, PeriodDataState>(
  (ref) => PeriodDataNotifier(ref),
);

class PeriodDataNotifier extends StateNotifier<PeriodDataState> {
  final Ref ref;
  PeriodDataNotifier(this.ref) : super(PeriodDataState());

  Future<void> generateSummary(TimeRange period) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final allData = ref.read(allDaysProvider);
      final now = DateTime.now();
      List<DayInfoModel> filteredData;

      switch (period) {
        case TimeRange.none:
          state = state.copyWith(summary: null, loading: false);
          return;
        case TimeRange.weekData:
          filteredData = allData
              .where((d) => d.date.isAfter(now.subtract(Duration(days: 7))))
              .toList();
          break;
        case TimeRange.monthData:
          filteredData = allData
              .where((d) =>
                  d.date.isAfter(DateTime(now.year, now.month - 1, now.day)))
              .toList();
          break;
      }

      if (filteredData.isEmpty) {
        state = state.copyWith(
            summary: "No data available for this period.", loading: false);
        return;
      }

      final buffer = StringBuffer();

      for (final day in filteredData) {
        final dateFormatted =
            "${day.date.day.toString().padLeft(2, '0')}/${day.date.month.toString().padLeft(2, '0')}/${day.date.year}";
        buffer.writeln(dateFormatted);

        for (final routine in day.coachRoutines) {
          final statusText = routine.finished ? "completed" : "not completed";
          buffer.writeln("  - ${routine.name}: $statusText");
        }

        buffer.writeln();
      }

      state = state.copyWith(summary: buffer.toString().trim(), loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
