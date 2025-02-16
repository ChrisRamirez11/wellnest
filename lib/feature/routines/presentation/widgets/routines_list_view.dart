// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

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

    var list = [];
    for (var i = 0; i < dateModel.routines.length; i++) {
      list.add(RoutineTile(
        routine: dateModel.routines[i],
        index: i,
        fromRoutinesScreen: true,
      ));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...list,
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
            width: double.infinity,
            child: CustomButton(
              onClick: () => Navigator.of(context).pushNamed('/createRoutine'),
              text: 'CREATE A NEW ROUTINE',
              icon: Icon(Icons.add, size: 30, color: secondary,),
            ),
          )
        ],
      ),
    );
  }
}
