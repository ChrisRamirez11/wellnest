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
    final showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    Widget widget;

    if (failure != null) {
      widget = Center(child: Text('Error: $failure'));
    } else if (routines != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final activeRoutines = routines
          .where((r) => r.endAt == null || r.endAt!.isAfter(today))
          .toList();
      final endedRoutines = routines
          .where((r) => r.endAt != null && (!r.endAt!.isAfter(today)))
          .toList();

      if (activeRoutines.isEmpty && endedRoutines.isEmpty) {
        widget = _NoRoutinesPlaceholder();
      } else {
        widget = ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            ...activeRoutines.map((r) => RoutineTile(routine: r)),
            if (endedRoutines.isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    const SizedBox(width: 10),
                    Text(
                      localization(context).ended.toUpperCase(),
                      style: textTheme(context)
                          .bodyLarge!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              ...endedRoutines.map((r) => RoutineTile(routine: r)),
            ],
          ],
        );
      }
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CustomAppBar(
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleString: localization(context).routines,
        actionsList: [
          if (showFab) const CustomFab(isMini: true),
          const SizedBox(width: 10),
        ],
      ),
      body: widget,
    );
  }
}

class _NoRoutinesPlaceholder extends StatelessWidget {
  const _NoRoutinesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              localization(context).noRoutines,
              style: textTheme(context).labelLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              localization(context).motivationalMessage,
              style: textTheme(context).bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
