import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/adminRedeemedHistoryModel.dart';
import 'package:inco/presentation/views/admin/deliveryStatus.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class RedeemRequestScreen extends StatelessWidget {
  const RedeemRequestScreen({super.key,});
  

  @override
  Widget build(BuildContext context) {
    
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
        title: const Text(' Redeem Requestes',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(builder: (context, value, child) => 
           ListView.builder(
            itemCount:value.redeemRequestes!.length,
            itemBuilder: (BuildContext context, int index) {
              AdminRedeemedHistoryModel request = value.redeemRequestes![index];
              return Card(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12,
                        image: DecorationImage(
                            image: NetworkImage(
                              '${Api.baseUrl}storage/${request.productImage!}'
                                  .replaceAll('api', ''),
                            ),
                            fit: BoxFit.fill),
                      ),
                      margin: const EdgeInsets.all(5),
                      height: 80,
                      width: 120,
                    ),
                    Expanded(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DeliveryStatusScreen(details: request)));
                        },
                        title: Text(
                          request.name!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(request.address!),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
