import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/drawer.dart';
import 'package:inco/data/model/progressCountMode.dart';
import 'package:inco/presentation/views/admin/generateQR.dart';
import 'package:inco/presentation/views/admin/pointRequest.dart';
import 'package:inco/presentation/views/admin/productListScreen.dart';
import 'package:inco/presentation/views/admin/redeemRequest.dart';
import 'package:inco/presentation/views/admin/usersListScreen.dart';
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/userProvider.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomeDrawer(),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) => NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctxt) => QrGenerationScreen()));
                      },
                      icon: Icon(
                        Icons.qr_code_2_outlined,
                        size: 30,
                      )),
                  SizedBox(
                    width: 10,
                  )
                ],
                leading: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.account_circle_outlined,
                      size: 37,
                    )),
                pinned: true,
                floating: true,
                backgroundColor: appThemeColor,
                title: Text('INCO ADMIN',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
                centerTitle: true,
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .getAllUsers();
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctxt) => UsersListScreen()))
                                  .then((_) {
                                value.getProgressAndCount();
                              });
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: mediaqry.height * 0.16,
                                width: mediaqry.width * 0.43,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Users',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      value.progressdata!.activeUsers
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .redeemrequestmarkTOShipped();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctxt) =>
                                          RedeemRequestScreen())).then((_) {
                                value.getProgressAndCount();
                              });
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: mediaqry.height * 0.16,
                                width: mediaqry.width * 0.43,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Requests',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                          textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      value.progressdata!.redeemedRequests
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .fetchProducts();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctxt) =>
                                          ProductListScreen())).then((_) {
                                value.getProgressAndCount();
                              });
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: mediaqry.height * 0.16,
                                width: mediaqry.width * 0.43,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Products',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      value.progressdata!.products.toString(),
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .getPointRequestes();
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctxt) =>
                                          PointRequestScreen())).then((_) {
                                value.getProgressAndCount();
                              });
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: mediaqry.height * 0.16,
                                width: mediaqry.width * 0.43,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Reports',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      value.progressdata!.complaints.toString(),
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '  Order Progress',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      ProductPercentage product =
                          value.progressdata!.productPercentages[index];
                      return Card(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black12,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      '${Api.baseUrl}storage/${product.productImage}'
                                          .replaceAll('api', ''),
                                    ),
                                    fit: BoxFit.fill),
                              ),
                              margin: EdgeInsets.all(5),
                              height: 100,
                              width: 150,
                            ),
                            Expanded(
                              child: ListTile(
                                title: Container(
                                  height: mediaqry.height * 0.08,
                                  child: Text(product.productInfo),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: LinearProgressIndicator(
                                    minHeight: 8,
                                    color: appThemeColor,
                                    value: product.percentage,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: value.progressdata!.productPercentages.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPointContainer(
      BuildContext context, double height, double width, heading, point) {
    return Card(
        elevation: 5,
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                heading,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                point,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
