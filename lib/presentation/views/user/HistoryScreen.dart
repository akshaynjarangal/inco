import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/userRedeemHistoryModel.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<UserRedeemedHistoryModel>? products =
        Provider.of<ProductProvider>(context, listen: false).userRedemedHistory;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appThemeColor,
        centerTitle: true,
        title: const Text('Redeemed History',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products!.length,
                itemBuilder: (BuildContext context, int index) {
                  UserRedeemedHistoryModel product = products[index];
                  return Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(product.productInfo),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipped to:',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(product.address),
                                Text(
                                  product.status,
                                  style: TextStyle(
                                    color: product.status == 'pending'
                                        ? const Color.fromARGB(255, 167, 151, 9)
                                        : product.status == 'shipped'
                                            ? Colors.green
                                            : Colors
                                                .black, // Default color if none of the conditions match
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black12,
                            image: DecorationImage(
                                image: NetworkImage(
                                  '${Api.baseUrl}storage/${product.productImage!}'
                                      .replaceAll('api', ''),
                                ),
                                fit: BoxFit.fill),
                          ),
                          margin: EdgeInsets.all(5),
                          height: 100,
                          width: 150,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
