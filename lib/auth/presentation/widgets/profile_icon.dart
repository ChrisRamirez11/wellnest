import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 130,
      width: 130,
        decoration: const BoxDecoration(shape: BoxShape.circle,color: primary
        ),
        child: const Icon(
          Icons.person_2,
          color: secondary,
          size: 100,
        ));
  }
}
