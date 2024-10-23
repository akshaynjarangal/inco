import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inco/presentation/views/auth/splashScreen.dart';
import 'package:inco/presentation/views/user/HomeScreen.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/bottomNavigationProvider.dart';
import 'package:inco/state/connectivityProvider.dart'; 
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:inco/state/qrProvider.dart';
import 'package:inco/state/userProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  var androidSettings = const AndroidInitializationSettings('ic_launcher');
  var initializationSettings = InitializationSettings(android: androidSettings);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider()
            ..fetchProducts()
            ..getProgressAndCount()
            ..getUserRedeemHistory(),
        ),
        ChangeNotifierProvider(
          create: (context) => QrProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider()..fetchProfile(),
        ),
        ChangeNotifierProvider(
          create: (context) => BannerProvider()..getUserTotalPoint(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNAvigationProvider(),

        ),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
