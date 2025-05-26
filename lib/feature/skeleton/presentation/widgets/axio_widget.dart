import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:wellnest/core/theme/theme.dart';

class AxioWidget extends StatefulWidget {
  const AxioWidget({super.key});

  @override
  State<AxioWidget> createState() => _AxioWidgetState();
}

class _AxioWidgetState extends State<AxioWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        RiveAnimation.asset(
          'assets/rive/axio.riv',
          artboard: 'Axio Idle',
          fit: BoxFit.cover,
        )
      ],
    );
  }
}
