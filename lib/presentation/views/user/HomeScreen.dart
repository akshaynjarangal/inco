import 'package:barcode_scan2/model/model.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/customeSlider.dart';
import 'package:inco/core/widgets/drawer.dart';
import 'package:inco/core/widgets/snackbar.dart';
import 'package:inco/data/model/deliveryAddressModel.dart';
import 'package:inco/data/model/productModel.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/presentation/views/user/confirmOrderScreen.dart';
import 'package:inco/presentation/views/user/notifications.dart';
import 'package:inco/service/adminService.dart';
import 'package:inco/service/userScrvice.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/connectivityProvider.dart';
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({super.key});

  final ValueNotifier<int> _current = ValueNotifier(0);
  final CarouselSliderController _controller = CarouselSliderController();

  String qrCodeResult = "Not Yet Scanned";

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
    List<ProductModel>? productprovider =
        Provider.of<ProductProvider>(context, listen: false).productList;
    return Scaffold(
      drawer: const CustomeDrawer(),
      body: Stack(children: [
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                backgroundColor: appThemeColor,
                title: const Text('INCO',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () async {
                        await Provider.of<BannerProvider>(context,
                                listen: false)
                            .getNotifications(false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationPage()));
                      },
                      icon: const Icon(Icons.notifications_none))
                ],
              ),
            ];
          },
          body: RefreshIndicator(
            color: appThemeColor,
            onRefresh: () async {
              var profileprovider =
                  Provider.of<ProfileProvider>(context, listen: false);
              var productprovider =
                  Provider.of<ProductProvider>(context, listen: false);
              await Provider.of<BannerProvider>(context, listen: false)
                  .getBanners();
              await Provider.of<BannerProvider>(context, listen: false)
                  .getUserTotalPoint();
              await profileprovider.fetchProfile();
              await productprovider.fetchProducts();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Consumer<BannerProvider>(
                          builder: (context, value, child) => CustomCarousel(
                            items: value.bannerImages,
                            carouselController: _controller,
                            current: _current,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Consumer<BannerProvider>(
                          builder: (context, value, child) => Card(
                            color: appThemeColor,
                            elevation: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // width: mediaqry.width * 0.6,
                                // decoration: BoxDecoration(
                                //   color: const Color.fromARGB(2, 0, 0, 0),
                                //   borderRadius: BorderRadius.circular(5),
                                //   border: Border.all(color: Colors.black12),
                                // ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: mediaqry.width * 0.03,
                                    ),
                                    Image.asset(
                                      'assets/images/point.png',
                                      height: 100,
                                      width: 100,
                                    ),

                                    SizedBox(
                                      width: mediaqry.width * 0.1,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Points earned',
                                          style: TextStyle(
                                              fontSize: mediaqry.height * 0.015,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          value.userTotalPoint ?? "0.0",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.normal,
                                              fontSize: mediaqry.height * 0.05,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),

                                    // buildPointContainer(context, 150, mediaqry.width * 0.3,
                                    //
                                    SizedBox(
                                      width: mediaqry.width * 0.2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            AdminService adminserv = AdminService();
                            var options = const ScanOptions(
                                android: AndroidOptions(useAutoFocus: true));
                            ScanResult result = await BarcodeScanner.scan(
                              options: options,
                            );

                            qrCodeResult = result.rawContent;
                            Response? res =
                                await adminserv.uploadScannedData(qrCodeResult);
                            // print(qrCodeResult);
                            bool status =
                                res!.data['status'] == 'success' ? true : false;
                            bool reportstatus =
                                res.data['status'] == 'failed' ? true : false;

                            showDialog(
                              context: context,
                              builder: (contextt) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Round the dialog edges
                                ),
                                title: Center(
                                  child: status
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.star,
                                            color: Color.fromARGB(
                                                255, 244, 222, 22),
                                            size: 60,
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.error,
                                            size: 60,
                                            color: Colors.red,
                                          ),
                                        ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical:
                                        10), // Reduce padding inside the dialog
                                content: SizedBox(
                                  width:
                                      250, // Set a fixed width for the content
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${res.data['message']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        textAlign:
                                            TextAlign.center, // Center the text
                                      ),
                                    ],
                                  ),
                                ),
                                actionsPadding: const EdgeInsets.only(
                                    bottom: 10,
                                    left: 10,
                                    right:
                                        10), // Adjust padding for the actions
                                actions: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (reportstatus)
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () async {
                                              UserService userService =
                                                  UserService();
                                              await userService
                                                  .pointRepportSent(
                                                      qrCodeResult, context);
                                            },
                                            color: const Color.fromARGB(
                                                255, 225, 208, 52),
                                            child: const Text('REPORT'),
                                          ),
                                        ),
                                      if (reportstatus)
                                        const SizedBox(width: 5),
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: () async {
                                            Provider.of<BannerProvider>(context,
                                                    listen: false)
                                                .getNotifications(true);
                                            Provider.of<BannerProvider>(context,
                                                    listen: false)
                                                .getUserTotalPoint();
                                            Navigator.of(contextt)
                                                .pop(); // Close dialog on OK press
                                          },
                                          color: appThemeColor,
                                          child: const Text('OK'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(11, 0, 0, 0),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Scan Now',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: mediaqry.width * 0.5,
                                        child: const Divider(
                                          thickness: 1,
                                          height: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Text(
                                        'Scan QR to get points',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/qrcode.png')),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '  Gifts for you',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<ProductProvider>(
                    builder: (context, value, child) => SliverToBoxAdapter(
                      child: SizedBox(
                        height: mediaqry.height *
                            0.2, // Adjust the height to fit the items properly
                        child: ListView.builder(
                          scrollDirection: Axis
                              .horizontal, // Set scroll direction to horizontal
                          itemCount: productprovider.length,
                          itemBuilder: (BuildContext context, int index) {
                            ProductModel product = productprovider[index];

                            return InkWell(
                              onTap: () async {
                                UserModel? user = Provider.of<ProfileProvider>(
                                        context,
                                        listen: false)
                                    .currentUserProfileData;
                                Provider.of<ProductProvider>(context,
                                        listen: false)
                                    .setdeliveryaddress(
                                  DeliveryAddress(
                                    name: user!.name,
                                    place: user.place,
                                    city: user.city,
                                    district: user.district,
                                    pincode: user.pincode,
                                    phone: user.phone,
                                  ),
                                );
                                var point = Provider.of<BannerProvider>(context,
                                        listen: false)
                                    .userTotalPoint;
                                if (int.parse(point ?? '0') >=
                                    int.parse(product.point!)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmOrderScreen(
                                        product: product,
                                      ),
                                    ),
                                  );
                                } else {
                                  snackbarWidget(
                                      context,
                                      'You don\'t have points to redeem',
                                      Colors.black);
                                }
                              },
                              child: Card(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${Api.baseUrl}${product.productImage!}'
                                                .replaceAll('api', ''),
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.black12,
                                      ),
                                      margin: const EdgeInsets.all(5),
                                      height: mediaqry.height * 0.2,
                                      width: mediaqry.width * 0.5,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      ]),
    );
  }

  // Widget buildPointContainer(
  //     BuildContext context, double height, double width, heading, point) {
  //   return Card(
  //       elevation: 5,
  //       child: Container(
  //         height: height,
  //         width: width,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               heading,
  //               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               point,
  //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
  //             ),
  //             SizedBox(height: 20),
  //           ],
  //         ),
  //       ));
  // }
}
