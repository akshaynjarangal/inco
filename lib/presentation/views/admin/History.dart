import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/adminRedeemedHistoryModel.dart';

class ProductHistoryScreen extends StatelessWidget {
  const ProductHistoryScreen({super.key, required this.history});
  final List<AdminRedeemedHistoryModel> history;

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
        title: const Text('Product History',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
        history.isEmpty||history.isEmpty ?const Center(child: Text('No Items'),):
        ListView.builder(
          itemCount: history.length,
          itemBuilder: (BuildContext context, int index) {
            AdminRedeemedHistoryModel product = history[index];
            return Card(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black12,
                      image: DecorationImage(
                          image: NetworkImage(
                            '${Api.baseUrl}${product.productImage!}'
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
                      title: Text(
                        product.productInfo!,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name!),
                          Text(product.address!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
