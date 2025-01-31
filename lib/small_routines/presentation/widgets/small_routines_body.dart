import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_error_widget.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/dates/presentation/widgets/custom_calendar.dart';
import 'package:wellnest/routines/presentation/widgets/routines_list_view.dart';
class SmallRoutinesBody extends ConsumerStatefulWidget {
  const SmallRoutinesBody({
    super.key,
  });

  @override
  ConsumerState<SmallRoutinesBody> createState() => _SmallRoutinesBodyState();
}

class _SmallRoutinesBodyState extends ConsumerState<SmallRoutinesBody> {

  @override
  Widget build(BuildContext context) {
    final dateNotifier = ref.watch(dateProvider);
    final dates = ref.watch(dateProvider).dates;
    final failure = ref.watch(dateProvider).failure;
    late Widget widget;
    if (dates != null) {
      widget = Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: size(context).width * .7,
              width: size(context).width,
              child: const CustomCalendar()),
          Expanded(
            child: dates.isNotEmpty
                ? RoutinesListView(
                    dateModel: dates[dateNotifier.currentIndex],
                  )
                : const SizedBox(),
          )
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
