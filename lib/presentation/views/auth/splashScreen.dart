import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/presentation/views/admin/adminHomeScreen.dart';
import 'package:inco/presentation/views/auth/loginScreen.dart';
import 'package:inco/presentation/views/user/bottomNavigationBar.dart';
import 'package:inco/service/auth.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigation();
    super.initState();
  }

  void navigation() async {
    await Future.delayed(Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthService.userType = await prefs.getString('usertype');
    print(AuthService.userType);
    if (AuthService.userType == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctxt) => LoginScreen()));
    } else {
      if (AuthService.userType == 'user') {
        var profileprovider =
            Provider.of<ProfileProvider>(context, listen: false);
        var productprovider =
            Provider.of<ProductProvider>(context, listen: false);
        await Provider.of<BannerProvider>(context, listen: false).getBanners();
        await Provider.of<BannerProvider>(context, listen: false)
            .getUserTotalPoint();
        await profileprovider.fetchProfile();
        await productprovider.fetchProducts();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctxt) => BottomNavigationBarScreen()));
      } else {
        await Provider.of<ProductProvider>(context, listen: false)
            .getProgressAndCount();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctxt) => AdminHomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                width: MediaQuery.of(context).size.width * 0.7,
                'assets/images/indu logo.png',
                // fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.7,
              child: SvgPicture.asset(
                'assets/images/inco.svg',
                color: appThemeColor, // Path to your SVG file in assets
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
