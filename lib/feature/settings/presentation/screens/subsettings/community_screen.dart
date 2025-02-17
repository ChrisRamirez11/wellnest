import 'package:flutter/material.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/settings/data/datasources/community_list.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(titleString: 'Contributors'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: communityList.length,
          itemBuilder: (context, index) => ListTile(
            title: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  height: 30,
                  child: FittedBox(child: Text(communityList[index]))),
            ),
          ),
        ),
      ),
    ));
  }
}
