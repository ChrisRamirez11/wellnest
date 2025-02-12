import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/small_routines/presentation/widgets/small_routines_body.dart';

class SmallRoutinesScreen extends ConsumerStatefulWidget {
  const SmallRoutinesScreen({super.key});

  @override
  ConsumerState<SmallRoutinesScreen> createState() =>
      _SmallRoutinesScreenState();
}

class _SmallRoutinesScreenState extends ConsumerState<SmallRoutinesScreen> {

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
