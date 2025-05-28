import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AxioAnimationController {
  late StateMachineController _stateMachineController;
  late SMIBool? isHappy;
  late SMINumber? progress;

  Future<Artboard> load() async {
    final data = await rootBundle.load('assets/rive/axio.riv');
    final file = RiveFile.import(data);
    final artboard = file.artboards.where((artboard) => artboard.name == 'Axio Idle').first;

    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'axions',
    )!;
    artboard.addController(_stateMachineController);

    isHappy = _stateMachineController.findInput<bool>('isHappy') as SMIBool?;
    progress = _stateMachineController.findInput<double>('progress') as SMINumber?;

    return artboard;
  }

  void setHappy(bool value) {
    isHappy?.value = value;
  }

  void setProgress(double value) {
    progress?.value = value;
  }
}
