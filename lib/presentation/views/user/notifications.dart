import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/notificationModel.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
        title: const Text('Notification',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: SafeArea(
        child: Consumer<BannerProvider>(
          builder: (context, value, child) => ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: value.notificationList!
                .length, // You can change this based on your needs
            itemBuilder: (context, index) {
              return NotificationTile(
                data: value.notificationList![index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotiFication data;

  const NotificationTile({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: ListTile(
        visualDensity: VisualDensity.standard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 20,
          backgroundImage: NetworkImage(
            '${Api.baseUrl}storage/${data.image}'.replaceAll('api', ''),
          ),
        ),
        title: Text(
          data.message,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              data.createdAt.toString().substring(0, 10) ==
                      DateTime.now().toString().substring(0, 10)
                  ? 'Today'
                  : data.createdAt.toString().substring(0, 10),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
