import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/core/widgets/custom_error_widget.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/routines/presentation/widgets/routines_body.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider).routines;
    final failure = ref.watch(routineProvider).failure;
    late Widget? widget;

    if (routines != null) {
      widget = RoutinesBody(routines: routines);
    } else if (failure != null) {
      widget = CustomErrorWidget(errorMessage: failure.errorMessage);
    } else {
      widget = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        titleString: 'Small Routines',
      ),
      body: widget,
    );
  }
}
