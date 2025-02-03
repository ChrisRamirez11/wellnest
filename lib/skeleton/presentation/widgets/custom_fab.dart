import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomFab extends ConsumerWidget {
  const CustomFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => Navigator.of(context).pushNamed('/createRoutine'),
        child: const Icon(Icons.add));
  }
}
