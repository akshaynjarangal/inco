import 'package:flutter/material.dart';
import 'package:inco/presentation/views/user/HistoryScreen.dart';
import 'package:inco/presentation/views/user/HomeScreen.dart';
import 'package:inco/presentation/views/user/profileScreen.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class BottomNAvigationProvider extends ChangeNotifier {
  int _currentIndex = 0; // To keep track of the selected index
  int get currentIndex => _currentIndex;
  final List<Widget> _pages = [
    UserHomeScreen(),
    const HistoryScreen(),
    const MyAccountPage(),
  ];

  List<Widget> get pages => _pages;

  screenChange(int index, context) async {
    if (index == 1) {
      await Provider.of<ProductProvider>(context, listen: false)
          .getUserRedeemHistory();
    }
    _currentIndex = index;
    notifyListeners();
  }
}
