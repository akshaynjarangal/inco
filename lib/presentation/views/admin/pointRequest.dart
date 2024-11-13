import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/presentation/views/admin/requestDetails.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class PointRequestScreen extends StatelessWidget {
  const PointRequestScreen({super.key});

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
        title: const Text('Reports',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(
          builder: (context, value, child) => 
           value.pointRequestes!.isEmpty||value.pointRequestes==null?const Center(child: Text('No Requestes'),):
          ListView.builder(
            itemCount: value.pointRequestes!.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctxt) => RequesteDetailsScreen(
                                  reqDetails: value.pointRequestes![index],
                                )));
                  },
                  title: Text(
                    value.pointRequestes![index].complainant.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(value.pointRequestes![index].complainant.phone
                      .toString()),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        '${Api.baseUrl}${value.pointRequestes![index].complainant.image!}'
                            .replaceAll('api', '')),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
