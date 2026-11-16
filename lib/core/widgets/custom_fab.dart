import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/theme/theme.dart';

class CustomFab extends ConsumerWidget {
  final bool? isMini;
  const CustomFab({super.key, this.isMini});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
        mini: isMini ?? false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => Navigator.of(context).pushNamed('/createRoutine'),
        child: const Icon(
          Icons.add,
          color: ghostWhite,
          size: 30,
        ));
  }
}
