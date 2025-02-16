import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_error_widget.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/dates/presentation/widgets/custom_calendar.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/widgets/routines_list_view.dart';

class SmallRoutinesBody extends ConsumerWidget {
  const SmallRoutinesBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateNotifier = ref.watch(dateProvider);
    final dates = ref.watch(dateProvider).dates;
    final failure = ref.watch(dateProvider).failure;
    final routines = ref.watch(routineProvider).routines;
    late Widget widget;
    if (dates != null && routines != null) {
      widget = SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: size(context).width * .7,
                width: size(context).width,
                child: CustomCalendar(
                  routines: routines,
                )),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .45,
                minHeight: MediaQuery.sizeOf(context).height * .2,
                maxWidth: MediaQuery.sizeOf(context).width,
              ),
              child: dateNotifier.date != null
                  ? RoutinesListView(dateModel: dateNotifier.date!)
                  : const SizedBox(),
            ),
          ],
        ),
      );
    } else if (failure != null) {
      widget = CustomErrorWidget(errorMessage: failure.errorMessage);
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }
}
