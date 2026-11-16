import 'package:flutter/material.dart';

class CustomFABLocation extends FloatingActionButtonLocation {
  final Offset offset;

  CustomFABLocation({this.offset = Offset.zero});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final defaultOffset =
        FloatingActionButtonLocation.miniEndFloat.getOffset(scaffoldGeometry);
    return defaultOffset + offset;
  }
}
