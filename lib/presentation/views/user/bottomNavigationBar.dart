import 'package:flutter/material.dart';
import 'package:inco/service/userScrvice.dart';
import 'package:inco/state/bottomNavigationProvider.dart';
import 'package:inco/state/connectivityProvider.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  UserService userService = UserService();

  // List of pages to display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          context.read<BottomNAvigationProvider>().screenChange(0, context);
        },
        canPop: context.watch<BottomNAvigationProvider>().currentIndex == 0
            ? true
            : false,
        child: Stack(
          children: [
            IndexedStack(
              index: context.watch<BottomNAvigationProvider>().currentIndex,
              children: context.watch<BottomNAvigationProvider>().pages,
            ),
            Consumer<ConnectivityProvider>(
              builder: (context, connectivityProvider, child) {
                if (connectivityProvider.isOffline) {
                  return Positioned.fill(
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.8), // Semi-transparent background
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Colors.white,
                              size: 100,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'You are offline',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Please check your internet connection',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Do nothing if online
              },
            ),
          ],
        ),
      ), // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context
            .watch<BottomNAvigationProvider>()
            .currentIndex, // Current selected index
        onTap: (index) async {
          // var provider = Provider.of<ProfileProvider>(context, listen: false);
          // var productProvider =
          //     Provider.of<ProductProvider>(context, listen: false);
          // if (index == 2 || index == 0) {
          //   await provider.fetchProfile();
          //   await productProvider.fetchProducts();
          //   await Provider.of<BannerProvider>(context, listen: false)
          //       .getUserTotalPoint();
          // }
          // if (index == 1) {
          //   productProvider.userRedemedHistory =
          //       await userService.getUserRedeemedHistory();
          // }

          context.read<BottomNAvigationProvider>().screenChange(index, context);
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
