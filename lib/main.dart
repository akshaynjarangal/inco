import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inco/presentation/views/admin/adminHomeScreen.dart';
import 'package:inco/presentation/views/auth/forgotPass.dart';
import 'package:inco/presentation/views/auth/loginScreen.dart';
import 'package:inco/presentation/views/auth/otpScreen.dart';
import 'package:inco/presentation/views/auth/passwordScreen.dart';
import 'package:inco/presentation/views/auth/registerScreen.dart';
import 'package:inco/presentation/views/auth/splashScreen.dart';
import 'package:inco/presentation/views/user/HomeScreen.dart';
import 'package:inco/presentation/views/user/bottomNavigationBar.dart';
import 'package:inco/presentation/views/user/notifications.dart';
import 'package:inco/presentation/views/user/profileScreen.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:inco/state/qrProvider.dart';
import 'package:inco/state/userProvider.dart';
import 'package:inco/test.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  var androidSettings = AndroidInitializationSettings('ic_launcher');
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
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QrProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BannerProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
