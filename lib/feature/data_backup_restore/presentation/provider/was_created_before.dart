import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wasCreatedBeforeProvider = ChangeNotifierProvider((ref) => WasCreatedBefore(),);

class WasCreatedBefore extends ChangeNotifier{
  bool _was = false;

  bool get was => _was;

  void setValue(bool value){
    _was = value;
    notifyListeners();
  }
}