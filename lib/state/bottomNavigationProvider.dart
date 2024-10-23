import 'package:flutter/material.dart';
import 'package:inco/presentation/views/user/HistoryScreen.dart';
import 'package:inco/presentation/views/user/HomeScreen.dart';
import 'package:inco/presentation/views/user/profileScreen.dart';

class BottomNAvigationProvider extends ChangeNotifier {
  int _currentIndex = 0; // To keep track of the selected index
   int get  currentIndex => _currentIndex;
  final List<Widget> _pages = [
    UserHomeScreen(),
    const HistoryScreen(),
    const MyAccountPage(),
  ];

  List<Widget> get pages => _pages;

  set screenChange(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
