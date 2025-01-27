import 'package:flutter/material.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';

class RoutineTile extends StatelessWidget {
  final RoutineModel routineModel;
  const RoutineTile({
    super.key,
    required this.routineModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routineModel.name),
                    ],
                  ),
                  Expanded(child: const SizedBox()),
                  Text(routineModel.duration.toString()),
                ],
              ),
            ],
          )),
    );
  }
}
