import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomFab extends ConsumerWidget {
  const CustomFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
        onPressed: () async {
        },
        child: Icon(Icons.add));
  }
}
