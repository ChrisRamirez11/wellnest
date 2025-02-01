// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/core/widgets/custom_error_widget.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/routines/presentation/widgets/routine_tile.dart';

class RoutinesListView extends ConsumerWidget {
  final DateModel dateModel;

  const RoutinesListView({
    super.key,
    required this.dateModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider).routines;
    final failure = ref.watch(routineProvider).failure;
    late Widget widget;

    if (routines != null) {
      log('routinesListView ${dateModel.id.toString()}');
      widget = ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) {
            if (dateModel.routinesId.contains(routines[index].id)) {
              return RoutineTile(routineModel: routines[index]);
            } else {
              return const SizedBox();
            }
          });
    } else if (failure != null) {
      widget = CustomErrorWidget(errorMessage: failure.errorMessage);
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }
}
