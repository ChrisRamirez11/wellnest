// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/routines/presentation/widgets/routine_tile.dart';

class RoutinesListView extends ConsumerWidget {
  final DateModel dateModel;

  const RoutinesListView({
    super.key,
    required this.dateModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        itemCount: dateModel.routines.length,
        itemBuilder: (context, index) {
          return RoutineTile(
            routine: dateModel.routines[index],
            index: index,
            fromRoutinesScreen: true,
          );
        });
  }
}
