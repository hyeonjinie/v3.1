import 'package:flutter/material.dart';

class MainScreenState extends ChangeNotifier {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int get selectedIndex => _selectedIndex;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Ensure selectedIndex is within bounds
  void validateIndex(int maxIndex) {
    if (_selectedIndex >= maxIndex) {
      _selectedIndex = 0;
      notifyListeners();
    }
  }
}
