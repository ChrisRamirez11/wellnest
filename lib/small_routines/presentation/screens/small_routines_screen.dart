import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/small_routines/presentation/widgets/small_routines_body.dart';

class SmallRoutinesScreen extends ConsumerWidget {
  const SmallRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        titleString: 'Small Routines',
      ),
      body: const SmallRoutinesBody(),
    );
  }
}
