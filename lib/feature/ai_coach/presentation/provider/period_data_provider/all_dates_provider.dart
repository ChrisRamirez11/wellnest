import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/ai_coach/data/models/day_info_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';

final allDaysProvider = Provider<List<DayInfoModel>>((ref) {
  final dateProviderData = ref.watch(dateProvider);
  return dateProviderData.dates!
      .map((dateModel) => DayInfoModel.fromDateModel(dateModel))
      .toList();
});
