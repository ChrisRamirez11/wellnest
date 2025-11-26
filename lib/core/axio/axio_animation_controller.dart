import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AxioAnimationController {
  late File _file;
  late Artboard _artboard;
  late StateMachine _stateMachine;
  late BooleanInput? isHappy;
  late NumberInput? progress;

  Future<Artboard> load() async {
    final data = await rootBundle.load('assets/rive/axio.riv');
    _file = await File.decode(
      data.buffer.asUint8List(),
      riveFactory: Factory.flutter,
    ) as File;

    // Get the "Axio Idle" artboard specifically
    final artboard = _file.artboard('Axio Idle');
    if (artboard == null) {
      throw Exception('Artboard "Axio Idle" not found');
    }

    _artboard = artboard;

    // Get the default state machine
    final stateMachine = _artboard.defaultStateMachine();
    if (stateMachine == null) {
      throw Exception('State machine not found on Axio Idle artboard');
    }

    _stateMachine = stateMachine;

    // Get inputs directly from the StateMachine (v0.14.0-dev.14+)
    isHappy = _stateMachine.boolean('isHappy');
    progress = _stateMachine.number('progress');

    debugPrint('Axio animation loaded successfully');
    debugPrint('Artboard: ${_artboard.name}');
    debugPrint('State Machine: ${_stateMachine.name}');

    return _artboard;
  }

  File getFile() => _file;

  void setHappy(bool value) {
    isHappy?.value = value;
  }

  void setProgress(double value) {
    progress?.value = value;
  }

  void dispose() {
    _artboard.dispose();
    _file.dispose();
  }
}
