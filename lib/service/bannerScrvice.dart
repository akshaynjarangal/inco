import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/bannerModel.dart';
import 'package:inco/data/model/notificationModel.dart';
import 'package:inco/presentation/views/user/HomeScreen.dart';
import 'package:inco/service/auth.dart';

class BannerService {
  Dio dio = Dio();
// get banners

  Future<List<BannerModel>?> getBannersfun() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      // print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.getBanner, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        // print(data);

        // Map the response to a list of ProductModel
        List<BannerModel> productList = data
            .map((productJson) => BannerModel.fromJson(productJson))
            .toList();

        return productList;
      } else {
        // print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching products: $e');
      return null;
    }
  }

  // add banner
  Future<String?> addBanner(File imageFile) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        // Map<String, dynamic> userJson = profilrdata.toJson();
        FormData formData = FormData.fromMap({
          // ...userJson,
          "banner_image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
          // Add additional fields if needed
        });

        Response response = await dio.post(
          Api.addBanner, // API endpoint for updating profile image
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data', // Ensure this is correct
            },
          ),
        );
        // print(response.data);

        if (response.statusCode == 200) {
          // print('banner image updated successfully');
          return response.data['image'];
        } else {
          // print('Failed to update profile image: ${response.data}');
          return null;
        }
      } catch (e) {
        // print('Error updating profile image: $e');
        return null;
      }
    } else {
      // print('No token found, please login.');
      return null;
    }
  }

// banner delete
  Future<bool?> deleteBannersfun(id) async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      // print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.delete(
        '${Api.deleteBanner}/$id', // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products

        return true;
      } else {
        // print('Failed to fetch products: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error fetching products: $e');
      return false;
    }
  }

// edit banner
  Future<String?> editBanner(File imageFile, id) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        // Map<String, dynamic> userJson = profilrdata.toJson();
        FormData formData = FormData.fromMap({
          // ...userJson,
          "banner_image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
          // Add additional fields if needed
        });

        Response response = await dio.post(
          '${Api.editBanner}/$id', // API endpoint for updating profile image
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data', // Ensure this is correct
            },
          ),
        );
        print(response.data);

        if (response.statusCode == 200) {
          // print('banner image updated successfully');
          return response.data['image'];
        } else {
          // print('Failed to update profile image: ${response.data}');
          return null;
        }
      } catch (e) {
        // print('Error updating profile image: $e');
        return null;
      }
    } else {
      // print('No token found, please login.');
      return null;
    }
  }

  // getNotification
  Future<List<NotiFication>?> getNotificationfun(bool isSend) async {
    String? token = await AuthService.getToken(); // Fetch the token

    if (token == null) {
      // print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.getNotifications, // Replace with your API endpoint
      );
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Parse response data
        NotificationModell data = NotificationModell.fromJson(response.data);

        // Check if a notification should be sent
        try {
          if (isSend && data.newNotification != null) {
            showNotification(data.newNotification!.message, '');
          }
        } catch (e) {
          // print('cant show notification');
        }

        // Return the list of notifications
        return data.notifications;
      } else {
        // print('Failed to fetch notifications: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching notifications: $e');
      return null;
    }
  }

  void showNotification(String title, String body) async {
    // Use BigPictureStyleInformation without a large icon
    var bigPictureStyleInformation = BigPictureStyleInformation(
      const DrawableResourceAndroidBitmap(
          'ic_launcher'), // Replace this with your app icon
      largeIcon: const DrawableResourceAndroidBitmap('ic_launcher'),
      contentTitle: title,
      summaryText: body,
    );

    // Set the notification details with no large icon
    var androidDetails = const AndroidNotificationDetails(
      color:appThemeColor,
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority
          .high, // Make sure the priority is high for important notifications
      // styleInformation: bigPictureStyleInformation,
      fullScreenIntent: true,
      channelShowBadge: false,
      icon: 'ic_launcher', // Set the app icon here as the small icon
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (use a unique ID for each notification)
      title,
      body,
      notificationDetails,
    );
  }
}
