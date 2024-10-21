import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/data/model/adminRedeemedHistoryModel.dart';
import 'package:inco/service/adminService.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class DeliveryStatusScreen extends StatelessWidget {
  const DeliveryStatusScreen({super.key, required this.details});
  final AdminRedeemedHistoryModel details;

  @override
  Widget build(BuildContext context) {
    var medaquery = MediaQuery.of(context).size;
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
        title: const Text('Update Status',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    details.name!,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(details.address!),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Card(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12,
                    image: DecorationImage(
                        image: NetworkImage(
                          '${Api.baseUrl}storage/${details.productImage!}'
                              .replaceAll('api', ''),
                        ),
                        fit: BoxFit.fill),
                  ),
                  margin: const EdgeInsets.all(5),
                  height: 100,
                  width: 150,
                ),
                Expanded(
                  child: ListTile(
                    title: Text(details.productInfo!),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          CustomeButton(
              ontap: () async {
                AdminService adminService = AdminService();
                await adminService.changeStatusToShipped(context, details.id);
                await Provider.of<ProductProvider>(context, listen: false)
                    .redeemrequestmarkTOShipped();
                Navigator.pop(context);
              },
              height: 40,
              width: medaquery.width / 2,
              text: 'Mark as Shipped')
        ],
      ),
    );
  }
}
