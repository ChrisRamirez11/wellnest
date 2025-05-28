// axio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/axio/axio_animation_controller.dart';

final axioControllerProvider = Provider<AxioAnimationController>((ref) {
  return AxioAnimationController();
});
