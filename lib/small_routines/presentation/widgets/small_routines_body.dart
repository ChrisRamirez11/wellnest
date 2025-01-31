import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_error_widget.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/dates/presentation/widgets/custom_calendar.dart';
import 'package:wellnest/routines/presentation/widgets/routines_list_view.dart';
import 'package:wellnest/small_routines/presentation/providers/current_selected_date_provider.dart';

class SmallRoutinesBody extends ConsumerStatefulWidget {
  const SmallRoutinesBody({
    super.key,
  });

  @override
  ConsumerState<SmallRoutinesBody> createState() => _SmallRoutinesBodyState();
}

class _SmallRoutinesBodyState extends ConsumerState<SmallRoutinesBody> {
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    //if the actual day isnt created, it'll do it inside the getDate().
    await ref.watch(dateProvider).getDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        ref.watch(currentSelectedDateProvider).currentSelectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final currentSelectedDate =
        ref.watch(currentSelectedDateProvider).currentSelectedDate;
    final dates = ref.watch(dateProvider).dates;
    final failure = ref.watch(dateProvider).failure;
    final date = ref.watch(dateProvider).date;
    late Widget widget;
    if (dates != null) {
      log(date.toString());
      widget = Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: size(context).width * .7,
              width: size(context).width,
              child: const CustomCalendar()),
          Expanded(
            child: date != null ? RoutinesListView(
              dateModel: dates
                  .where(
                    (element) =>
                        element.date.isAtSameMomentAs(currentSelectedDate),
                  )
                  .first,
            ) : const SizedBox(),
          ),
        ],
      );
    } else if (failure != null) {
      widget = CustomErrorWidget(errorMessage: failure.errorMessage);
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }
}
