import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
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
        actionsList: [
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF004C63)),
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () => Navigator.of(context).pushNamed('/createRoutine'),
              child: Icon(
                Icons.add,
                color: secondary,
                size: 20,
                grade: 100,
                fill: 1,
              ),
            ),
          )
        ],
        titleString: 'CALENDAR',
      ),
      body: const SmallRoutinesBody(),
    );
  }
}
