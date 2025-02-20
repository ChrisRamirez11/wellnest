// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/ads/banner_ad.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/small_routines/presentation/widgets/small_routine_tile.dart';

class SmallRoutinesView extends ConsumerWidget {
  final DateModel dateModel;

  const SmallRoutinesView({
    super.key,
    required this.dateModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var list = [];
    for (var i = 0; i < dateModel.routines.length; i++) {
      list.add(SmallRoutineTile(
        routine: dateModel.routines[i],
        index: i,
      ));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...list,
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
            width: double.infinity,
            child: CustomButton(
              onClick: () => Navigator.of(context).pushNamed('/createRoutine'),
              text: 'CREATE A NEW ROUTINE',
              icon: Icon(Icons.add, size: 30, color: secondary,),
            ),
          ),
          BannerAdWidget()
        ],
      ),
    );
  }
}
