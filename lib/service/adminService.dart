import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/snackbar.dart';
import 'package:inco/data/model/adminRedeemedHistoryModel.dart';
import 'package:inco/data/model/deliveryAddressModel.dart';
import 'package:inco/data/model/pointRequestModel.dart';
import 'package:inco/data/model/productModel.dart';
import 'package:inco/data/model/progressCountMode.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/presentation/views/admin/adminHomeScreen.dart';
import 'package:inco/presentation/views/user/bottomNavigationBar.dart';
import 'package:inco/service/auth.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:provider/provider.dart';

class AdminService {
  Dio dio = Dio();
  Future<void> postDataWithTokenAndImage({
    required String productinfo, // First data field
    required String point, // Second data field
    required File imageFile, // Image file
  }) async {
    try {
      String? token = await AuthService.getToken();
      // Setting up the token in the headers
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Create FormData object to send data fields and file
      FormData formData = FormData.fromMap({
        "product_info": productinfo, // Data field 1
        "point": point, // Data field 2
        "product_image": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Send the POST request with FormData
      Response response = await dio.post(
        Api.addProduct, // The API endpoint
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // Necessary for file uploads
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Data posted successfully: ${response.data}");
      } else {
        print("Failed to post data: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error posting data: $e");
    }
  }

// get products
  Future<List<ProductModel>?> getProducts() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.getproducts, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        print(data);

        // Map the response to a list of ProductModel
        List<ProductModel> productList = data
            .map((productJson) => ProductModel.fromJson(productJson))
            .toList();

        return productList;
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  // delete
  Future<void> deleteProduct(productId) async {
    try {
      String? token = await AuthService.getToken(); // Get the token

      if (token != null) {
        // Set Authorization header
        dio.options.headers['Authorization'] = 'Bearer $token';

        // API call to delete the product
        Response response = await dio.delete(
          '${Api.deleteProduct}/$productId', // Replace with your API URL
        );

        if (response.statusCode == 200) {
          print('Product deleted successfully');
          // Handle successful delete, e.g., update product list
        } else {
          print('Failed to delete product: ${response.data}');
        }
      } else {
        print('No token found, please login.');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // scan qrcode

  Future<Response?> uploadScannedData(String data) async {
    try {
      // Get token from AuthService
      String? token = await AuthService.getToken();

      if (token != null) {
        // Add the token to the headers
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Make the POST request
        Response response = await dio.post(
          Api.uploadQrdata,
          data: {'data': data},
        );
        print(response.statusCode);
        print(response.data);
        // Check if the status code indicates success
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data posted successfully');
          return response;
        } else {
          print('Failed to post data: ${response.data}');
          return null;
        }
      } else {
        print('No token found, please login.');
        return null;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return null;
    }
  }

// redeem product
  Future<void> redeemProduct(
      ProductModel productdata, DeliveryAddress addres, context) async {
    try {
      // Get token from AuthService
      String? token = await AuthService.getToken();

      if (token != null) {
        // Add the token to the headers
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Make the POST request

        // Map<String, dynamic> addressjson = addres.toJson();
        Response response = await dio.post(
          Api.redeemProduct,
          data: {
            'product_id': productdata.id,
            'address':
                '${addres.name},${addres.place},${addres.city},${addres.district},${addres.pincode},Ph: ${addres.phone},'
          },
        );
        print(response.statusCode);
        print(response.data);
        // Check if the status code indicates success
        if (response.statusCode == 200 ||
            response.data['status'] == 'success') {
          print('Data posted successfully');
          snackbarWidget(context, response.data['message'], Colors.green);
          await Provider.of<BannerProvider>(context, listen: false)
              .getUserTotalPoint();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctxt) => BottomNavigationBarScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          snackbarWidget(context, response.data['message'], Colors.red);
          print('Failed to post data: ${response.data}');
        }
      } else {
        print('No token found, please login.');
      }
    } catch (e) {
      print('Error during POST request: $e');
    }
  }

  // admin redeemed history view
  Future<List<AdminRedeemedHistoryModel>?> adminRedeemedHistoryView() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.admingetRedeemedHistory, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        print(data);

        // Map the response to a list of ProductModel
        List<AdminRedeemedHistoryModel> productList = data
            .map((productJson) =>
                AdminRedeemedHistoryModel.fromJson(productJson))
            .toList();

        return productList;
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  // admin redeemed history view
  Future<List<AdminRedeemedHistoryModel>?> adminGetRedeemedRequestes() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.admingetRedeemedRequestes, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        print(data);

        // Map the response to a list of ProductModel
        List<AdminRedeemedHistoryModel> productList = data
            .map((productJson) =>
                AdminRedeemedHistoryModel.fromJson(productJson))
            .toList();

        return productList;
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  // mark as Shipped
  Future<void> changeStatusToShipped(context, id) async {
    try {
      // Get token from AuthService
      String? token = await AuthService.getToken();

      if (token != null) {
        // Add the token to the headers
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Make the POST request

        // Map<String, dynamic> addressjson = addres.toJson();
        Response response = await dio.post(
          '${Api.markAsShipped}/$id/status',
          data: {'status': 'shipped'},
        );
        print(response.statusCode);
        print(response.data);
        // Check if the status code indicates success
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data posted successfully');
          snackbarWidget(context, 'Status Updated', Colors.green);
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (ctxt) => AdminHomeScreen()),
          //   (Route<dynamic> route) => false,
          // );
        } else {
          print('Failed to post data: ${response.data}');
        }
      } else {
        print('No token found, please login.');
      }
    } catch (e) {
      print('Error during POST request: $e');
    }
  }

  // getPointRequestes
  Future<List<PointRequestesModel>?> getPointRequestes() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.getPointRequestes, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        print(data);

        // Map the response to a list of ProductModel
        List<PointRequestesModel> productList = data
            .map((productJson) => PointRequestesModel.fromJson(productJson))
            .toList();

        return productList;
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

// request Accept
  Future<Response?> acceptRequest(id) async {
    try {
      // Get token from AuthService
      String? token = await AuthService.getToken();

      if (token != null) {
        // Add the token to the headers
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Make the POST request
        Response response = await dio.post(
          '${Api.acceptRequest}/$id/accept',
        );
        print(response.statusCode);
        print(response.data);
        // Check if the status code indicates success
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data posted successfully');
          return response;
        } else {
          print('Failed to post data: ${response.data}');
          return null;
        }
      } else {
        print('No token found, please login.');
        return null;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return null;
    }
  }

  // request Reject
  Future<Response?> rejectRequest(id) async {
    try {
      // Get token from AuthService
      String? token = await AuthService.getToken();

      if (token != null) {
        // Add the token to the headers
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Make the POST request
        Response response = await dio.post(
          '${Api.acceptRequest}/$id/reject',
        );
        print(response.statusCode);
        print(response.data);
        // Check if the status code indicates success
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data posted successfully');
          return response;
        } else {
          print('Failed to post data: ${response.data}');
          return null;
        }
      } else {
        print('No token found, please login.');
        return null;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return null;
    }
  }

  Future<List<UserModel>?> getAllUsersfun() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.getAllUser, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        print(data);

        // Map the response to a list of ProductModel
        List<UserModel> productList =
            data.map((productJson) => UserModel.fromJson(productJson)).toList();

        return productList;
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  Future<List<UserModel>?> getSuspendedUsersfun() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.getSuspendedUser, // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<dynamic> data = response.data;
        print(data);

        // Map the response to a list of ProductModel
        List<UserModel> productList =
            data.map((productJson) => UserModel.fromJson(productJson)).toList();

        return productList;
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  // getProgressAnd Count
  Future<ProgressCountModel?> getProgressAndCountfun() async {
    String? token =
        await AuthService.getToken(); // Replace with your token fetching logic

    if (token == null) {
      print('Token is missing');
      return null;
    }

    try {
      // Configure Dio with the token
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Perform GET request
      Response response = await dio.get(
        Api.progressAndCount, // Replace with your API endpoint
      );

      // Print the response for debugging
      print(response.data);

      if (response.statusCode == 200) {
        // Assuming the response is an object, not a list
        Map<String, dynamic> data = response.data;
        print('hh');
        // Map the response to ProgressCountModel
        ProgressCountModel progressCount = ProgressCountModel.fromJson(data);
        print('hello');
        return progressCount;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
