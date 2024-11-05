import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/snackbar.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/data/model/userRedeemHistoryModel.dart';
import 'package:inco/service/auth.dart';
// import 'package:provider/provider.dart';

class UserService {
  Dio dio = Dio();

  Future<bool> updateUserProfile(updatedData) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';

        Map<String, dynamic> userJson = updatedData.toJson();
        Response response = await dio.put(
          Api.updateProfile, // API endpoint for updating the profile
          data: userJson, // Send the updated profile data
        );
        // print(response.data);
        if (response.statusCode == 200) {
          // print('Profile updated successfully');
          return response.data['message'].toString().contains('successfully');
        } else {
          // print('Failed to update profile: ${response.data}');
          return false;
        }
      } catch (e) {
        // print('Error updating profile: $e');
        return false;
      }
    } else {
      // print('No token found, please login.');
      return false;
    }
  }

  // update image

  Future<String?> updateProfileImage(
      File imageFile, UserModel profilrdata) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        Map<String, dynamic> userJson = profilrdata.toJson();
        FormData formData = FormData.fromMap({
          ...userJson,
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
          // Add additional fields if needed
        });

        Response response = await dio.post(
          Api.updateProfileImage, // API endpoint for updating profile image
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data', // Ensure this is correct
            },
          ),
        );
        // print(response.data);

        if (response.statusCode == 200 ||
            response.data['message'] == 'success') {
          // print('Profile image updated successfully');
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

  // get redeemed History
  Future<List<UserRedeemedHistoryModel>?> getUserRedeemedHistory() async {
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
        Api.getRedeemHistory, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        // print(data);

        // Map the response to a list of ProductModel
        List<UserRedeemedHistoryModel> productList = data
            .map(
                (productJson) => UserRedeemedHistoryModel.fromJson(productJson))
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

  Future<void> pointRepportSent(qrdata, context) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        Response response = await dio.post(
          Api.repportUser, // API endpoint for updating profile image
          data: {'qr_data': qrdata},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              // Ensure this is correct
            },
          ),
        );
        // print(response.data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          snackbarWidget(
              context, 'report send', const Color.fromARGB(255, 181, 168, 54));
          Navigator.pop(context);
        } else {
          // print('Failed to update profile image: ${response.data}');
        }
      } catch (e) {
        // print('Error updating profile image: $e');
      }
    } else {
      // print('No token found, please login.');
    }
  }

  Future<String?> suspendAndActivate(userid, context) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        Response response = await dio.put(
          '${Api.suspendAndActivate}/$userid', // API endpoint for updating profile image
          // data: {'qr_data': qrdata},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              // Ensure this is correct
            },
          ),
        );
        // print(response.data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          String status = response.data['status'];
          snackbarWidget(context, 'Account $status', Colors.black);
          // Navigator.pop(context);
          return status;
        } else {
          // print('Failed to update profile image: ${response.data}');
        }
      } catch (e) {
        // print('Error updating profile image: $e');
      }
    } else {
      // print('No token found, please login.');
    }
    return null;
  }

// changePassword
  Future<String?> changePassword(oldPassword, newPassword, context) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        Response response = await dio.post(
          Api.changePassword, // API endpoint for updating profile image
          data: {'current_password': oldPassword, 'new_password': newPassword},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              // Ensure this is correct
            },
          ),
        );
        // print(response.data);

        if (response.statusCode == 200 &&
                response.data['status'] == 'success' ||
            response.statusCode == 201 &&
                response.data['status'] == 'success') {
          String status = response.data['message'];
          snackbarWidget(context, status, Colors.black);
          Navigator.pop(context);

          return status;
        } else {
          String status = response.data['message'];
          snackbarWidget(context, status, Colors.black);
          // print('Failed to update password: ${response.data}');
        }
      } catch (e) {
        // print('Error updating password: $e');
        snackbarWidget(context, 'Somthing wrong', Colors.black);
      }
    } else {
      // print('No token found, please login.');
    }
    return null;
  }

  // getPoint
  Future<String?> getPointofUser() async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        Response response = await dio.get(
          Api.gettotalPoints, // API endpoint for updating profile image
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              // Ensure this is correct
            },
          ),
        );
        // print(response.data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data['points'].toString();
        } else {
          // print('Failed to update profile image: ${response.data}');
        }
      } catch (e) {
        // print('Error updating profile image: $e');
      }
    } else {
      // print('No token found, please login.');
    }
    return null;
  }
}
