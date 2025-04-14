import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = ChangeNotifierProvider(
  (ref) => ColorProvider(),
);

class ColorProvider extends ChangeNotifier {
  Color _color = Colors.blue;
  Color get color => _color;

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
}
