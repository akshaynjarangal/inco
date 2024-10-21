import 'package:flutter/material.dart';
import 'package:inco/presentation/views/user/HistoryScreen.dart';
import 'package:inco/presentation/views/user/HomeScreen.dart';
import 'package:inco/presentation/views/user/profileScreen.dart';
import 'package:inco/service/userScrvice.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0; // To keep track of the selected index
  UserService userService = UserService();

  // List of pages to display
  final List<Widget> _pages = [
    UserHomeScreen(),
    const HistoryScreen(),
    const MyAccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Current selected index
        onTap: (index) async {
          var provider = Provider.of<ProfileProvider>(context, listen: false);
          var productProvider =
              Provider.of<ProductProvider>(context, listen: false);
          if (index == 2 || index == 0) {
            await provider.fetchProfile();
            await productProvider.fetchProducts();
               await Provider.of<BannerProvider>(
                                                context,
                                                listen: false)
                                            .getUserTotalPoint();
          }
          if (index == 1) {
            productProvider.userRedemedHistory =
                await userService.getUserRedeemedHistory();
          }

          setState(() {
            _currentIndex = index; // Update selected index
          });
        },
        selectedItemColor: Colors.red, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for the unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
