// ignore_for_file: public_member_api_docs, sort_constructors_first
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
//Ya aqui no se puede depender de routines, solo de dateModel, routines solo sera para ver las rutinas exisentes, crearlas, etc(CRUD)

    if (routines != null) {
      widget = ListView.builder(
          itemCount: dateModel.routines.length,
          itemBuilder: (context, index) {
              return RoutineTile(routine: dateModel.routines[index], index: index,);
            
          });
    } else if (failure != null) {
      widget = CustomErrorWidget(errorMessage: failure.errorMessage);
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }
}
