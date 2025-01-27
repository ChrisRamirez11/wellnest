import 'package:flutter/material.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';
import 'package:wellnest/routines/presentation/widgets/routine_tile.dart';

class RoutinesBody extends StatelessWidget {
  final List<RoutineModel> routines;

  const RoutinesBody({
    super.key,
    required this.routines,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) => RoutineTile(routineModel: routines[index]),
    );
  }
}


