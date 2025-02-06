import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/small_routines/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/small_routines/presentation/widgets/small_routines_body.dart';

class SmallRoutinesScreen extends ConsumerStatefulWidget {
  const SmallRoutinesScreen({super.key});

  @override
  ConsumerState<SmallRoutinesScreen> createState() =>
      _SmallRoutinesScreenState();
}

class _SmallRoutinesScreenState extends ConsumerState<SmallRoutinesScreen> {
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await ref.watch(routineProvider).getRoutines();
    await ref.watch(dateProvider).getDates();
    await validateDateModel(ref.watch(routineProvider).routines!,
        ref.watch(currentSelectedDateProvider).currentSelectedDate, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleString: 'CALENDAR',
      ),
      body: const SmallRoutinesBody(),
    );
  }
}
