import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/presentation/views/user/changeAddressScreen.dart';
import 'package:inco/service/adminService.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatelessWidget {
  ConfirmOrderScreen({
    super.key,
    this.product,
  });
  final product;
  // final DeliveryAddress deliveryaddress;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
    // DeliveryAddress? deliveryaddress =
    //     Provider.of<ProductProvider>(context, listen: false).usedeliveryaddress;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        backgroundColor: appThemeColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Confirm Order',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(
          builder: (context, value, child) => Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(16, 0, 0, 0)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deliver to: ',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              value.usedeliveryaddress!.name!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${value.usedeliveryaddress!.place},\n${value.usedeliveryaddress!.city},\n${value.usedeliveryaddress!.district},\n${value.usedeliveryaddress!.pincode},',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Phone: ${value.usedeliveryaddress!.phone.toString()}',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctxt) => ChangeAddressScreen(
                                          address: value.usedeliveryaddress!,
                                          product: product,
                                        )));
                          },
                          child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: appThemeColor)),
                            child: const Center(
                              child: Text('change'),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              '${Api.baseUrl}storage/${product.productImage!}'
                                  .replaceAll('api', ''),
                            ),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12,
                      ),
                      margin: const EdgeInsets.all(5),
                      height: 100,
                      width: 150,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          product.point!,
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(product.productInfo!),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder:
                      (BuildContext context, dynamic valuee, Widget? child) {
                    return isLoading.value
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: appThemeColor,
                            ),
                          )
                        : CustomeButton(
                            ontap: () async {
                              isLoading.value = true;
                              AdminService adminService = AdminService();
                              await adminService.redeemProduct(
                                  product, value.usedeliveryaddress!, context);
                              await Provider.of<BannerProvider>(context,
                                      listen: false)
                                  .getNotifications(true);
                              isLoading.value = false;
                            },
                            height: 40,
                            width: mediaqry.width / 2,
                            text: 'Submit');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
