import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AxioAnimationController {
  late StateMachine _stateMachine;
  late SMIBool? isHappy;
  late SMINumber? progress;

  Future<Artboard> load() async {
    final data = await rootBundle.load('assets/rive/axio.riv');
    final file = RiveFile.import(data);
    final artboard = file.artboards.where((artboard) => artboard.name == 'Axio Idle').first;

    final stateMachine = artboard.defaultStateMachine();
    if (stateMachine == null) {
      throw Exception('State machine not found on Axio Idle artboard');
    }

    _stateMachine = stateMachine;

    // Use modern API to get inputs directly from StateMachine (v0.13.2+)
    isHappy = _stateMachine.boolean('isHappy');
    progress = _stateMachine.number('progress');

    return artboard;
  }

  void setHappy(bool value) {
    isHappy?.value = value;
  }

  void setProgress(double value) {
    progress?.value = value;
  }
}
