import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexProvider = ChangeNotifierProvider((ref) => IndexProvider());

class IndexProvider extends ChangeNotifier{
  var _selectedIndex = 0;
  final pageController = PageController();

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index){
    pageController.jumpToPage(index);
    _selectedIndex = index;
    notifyListeners();
  }
}