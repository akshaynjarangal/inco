import 'dart:io';

import 'package:flutter/cupertino.dart';
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

  var androidSettings = const AndroidInitializationSettings('ic_stat_name');
  var darwinSettings = const DarwinInitializationSettings();
  var initializationSettings =
      InitializationSettings(android: androidSettings, iOS: darwinSettings);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      child: Platform.isAndroid
          ? MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(useMaterial3: true),
              home: const SplashScreen(),
            )
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                cupertinoOverrideTheme: const CupertinoThemeData(
                  primaryColor: CupertinoColors.activeBlue,
                ),
              ),
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              home: const SplashScreen(),
            ),
    );
  }
}
