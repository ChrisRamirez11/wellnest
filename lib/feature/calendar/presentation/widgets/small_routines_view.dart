// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/core/theme/theme.dart';
import 'package:task_nest/core/widgets/custom_button.dart';

import 'package:task_nest/feature/dates/data/models/date_model.dart';
import 'package:task_nest/feature/calendar/presentation/widgets/small_routine_tile.dart';

const indentSize = 20.0;

class SmallRoutinesView extends StatefulWidget {
  final DateModel dateModel;

  const SmallRoutinesView({
    super.key,
    required this.dateModel,
  });

  @override
  State<SmallRoutinesView> createState() => _SmallRoutinesViewState();
}

class _SmallRoutinesViewState extends State<SmallRoutinesView> {
  @override
  Widget build(BuildContext context) {
    var list = <SmallRoutineTile>[];

    for (var i = 0; i < widget.dateModel.routines.length; i++) {
      list.add(SmallRoutineTile(
        routine: widget.dateModel.routines[i],
        index: i,
      ));
    }

    /* Sorting if you complete it
    list.sort(
      (a, b) => a.routine.finished! ? 1 : (b.routine.finished! ? -1 : 0),
    );
    */

    return SingleChildScrollView(
      child: Column(
        children: [
          ...list,
          list.isNotEmpty
              ? Divider(
                  endIndent: indentSize,
                  indent: indentSize,
                )
              : SizedBox.shrink(),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 35,
              right: 35,
            ),
            width: double.infinity,
            child: CustomButton(
              onClick: () => Navigator.of(context).pushNamed('/createRoutine'),
              text: localization(context).createNewRoutine.toUpperCase(),
              radius: 10,
              textColor: ghostWhite,
              icon: const Icon(Icons.add, size: 30, color: ghostWhite),
            ),
          ),
        ],
      ),
    );
  }
}
