import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:wellnest/core/axio/axio_animation_controller.dart';

class AxioAnimationWidget extends StatefulWidget {
  final AxioAnimationController controller;

  const AxioAnimationWidget({super.key, required this.controller});

  @override
  State<AxioAnimationWidget> createState() => _AxioAnimationWidgetState();
}

class _AxioAnimationWidgetState extends State<AxioAnimationWidget> {
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    widget.controller.load().then((artboard) {
      setState(() {
        _artboard = artboard;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_artboard == null) {
      return const SizedBox();
    }

    return Rive(artboard: _artboard!, fit: BoxFit.cover,);
  }
}
