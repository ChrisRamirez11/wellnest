// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:wellnest/feature/ads/banner_ad.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/small_routines/presentation/widgets/small_routine_tile.dart';

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

    list.sort(
      (a, b) => a.routine.finished! ? 1 : (b.routine.finished! ? -1 : 0),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          //an animatedlist can be set, and when you update a checkbox
          //it will do the removing and inserting in the list
          //MAYBE using a provider where a list = this.list and the list from
          //the provider will be used in the animatedList
          ...list,
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
            width: double.infinity,
            child: CustomButton(
              onClick: () => Navigator.of(context).pushNamed('/createRoutine'),
              text: 'CREATE A NEW ROUTINE',
              icon: Icon(
                Icons.add,
                size: 30,
                color: secondary,
              ),
            ),
          ),
          BannerAdWidget()
        ],
      ),
    );
  }
}
