import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/widgets/routine_model_tile.dart';
import 'package:wellnest/core/widgets/custom_fab.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesNotifier = ref.watch(routineProvider);
    final failure = routinesNotifier.failure;
    final routines = routinesNotifier.routines;
    late Widget widget;
    if (failure != null) {
      widget = Center(child: Text('Error: $failure'));
    } else if (routines != null) {
      widget = ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          return RoutineTile(
            routine: routines[index],
            index: index,
          );
        },
      );
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }

    final showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: CustomAppBar(
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleString: localization(context).routines,
        actionsList: [
          showFab
              ? const CustomFab(
                  isMini: true,
                )
              : const SizedBox(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: widget,
    );
  }
}
