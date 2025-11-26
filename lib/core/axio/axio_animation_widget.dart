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
  RiveWidgetController? _riveController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initRive();
  }

  Future<void> _initRive() async {
    try {
      await widget.controller.load();
      
      final file = widget.controller.getFile();
      final controller = RiveWidgetController(
        file,
        artboardSelector: ArtboardSelector.byName('Axio Idle'),
        stateMachineSelector: StateMachineSelector.byDefault(),
      );
      
      if (mounted) {
        setState(() {
          _riveController = controller;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading Rive animation: $e');
    }
  }

  @override
  void dispose() {
    _riveController?.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _riveController == null) {
      return const SizedBox();
    }

    return RiveWidget(
      controller: _riveController!,
      fit: Fit.cover,
    );
  }
}
