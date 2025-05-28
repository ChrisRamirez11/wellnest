import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/axio/axio_animation_widget.dart';
import 'package:wellnest/core/axio/axio_provider.dart';
import 'package:wellnest/core/theme/theme.dart';

class Axio extends ConsumerWidget {
  const Axio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: ghostWhite.withAlpha(50),
                  blurRadius: 20,
                  spreadRadius: 5),
            ],
          ),
        ),
        Icon(Icons.circle, color: ghostWhite, size: 60),
        AxioAnimationWidget(controller: ref.read(axioControllerProvider))
      ],
    );
  }
}
