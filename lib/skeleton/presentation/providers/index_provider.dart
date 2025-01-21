import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexProvider = ChangeNotifierProvider((ref) => IndexProvider());

class IndexProvider extends ChangeNotifier{
  var _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }
}