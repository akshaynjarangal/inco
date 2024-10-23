import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/snackbar.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/presentation/views/admin/adminHomeScreen.dart';
import 'package:inco/presentation/views/auth/loginScreen.dart';
import 'package:inco/presentation/views/user/bottomNavigationBar.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/productProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? adminEmail;
  static String? adminName;
  Dio dio = Dio();
  static String? userType;

  // Base URL of your API

  // Login function
  Future<void> login(String email, String password, context) async {
    try {
      // API endpoint for login

      // Request body (credentials)
      Map<String, dynamic> credentials = {
        'email': email,
        'password': password,
      };

      // Make POST request using Dio
      Response response = await dio.post(Api.login, data: credentials);
      print('ddd');
      print(response.statusCode);
      // Check if login was successful (e.g., 200 OK)
      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.data);
          // Extract token from the response (assuming it's in a field 'token')
          String? token = response.data['token'];
          String? type = response.data['user']['role'];
          print(token);
          print(response.data);
          // Store token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token!);
          await prefs.setString('usertype', type!);
          userType = type;

          print('Login successful! Token saved.');
          snackbarWidget(context, response.data['message'], Colors.green);
          // await Provider.of<ProfileProvider>(context).fetchProfile();
          if (userType == 'user') {
            var profileprovider =
                Provider.of<ProfileProvider>(context, listen: false);
            var productprovider =
                Provider.of<ProductProvider>(context, listen: false);
            await Provider.of<BannerProvider>(context, listen: false)
                .getBanners();
            await Provider.of<BannerProvider>(context, listen: false)
                .getUserTotalPoint();
            await profileprovider.fetchProfile();
            await productprovider.fetchProducts();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctxt) => const BottomNavigationBarScreen()));
          } else {
            await Provider.of<ProductProvider>(context, listen: false)
                .getProgressAndCount();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctxt) => const AdminHomeScreen()));
          }
        } else {
          snackbarWidget(context, response.data['message'], Colors.red);
          print('Login failed: ${response.data['message']}');
        }
      } catch (e) {
        snackbarWidget(context, response.data['message'], Colors.red);
      }
    } catch (e) {
      print('Error during login: $e');
      snackbarWidget(context, 'Somthing went wrong!', Colors.red);
    }
  }

  // Function to get the token from SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

//  fetch profile
// convert to  model
  Future<UserModel?> fetchUserProfile() async {
    String? token = await getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';
        Response response = await dio.get(Api.userProfile);
        print('Data fetched successfully: ${response.data}');
        UserModel user = UserModel.fromJson(response.data);
        return user;
      } catch (e) {
        print('Error fetching data: $e');
        return null; // Return null in case of error
      }
    } else {
      print('No token found, please login.');
      return null; // Return null if no token is found
    }
  }

  Future<void> register(context, data, otp) async {
    try {
      // API endpoint for registration is already defined in api.dart as Api.register

      // Send a POST request to the registration endpoint
      Map<String, dynamic> userJson = data.toJson();
      userJson['code'] = otp;
      userJson['phone'] = '+91${data.phone}';
      Response response = await dio.post(Api.register, data: userJson);

      // Check if registration was successful (status code 200 or 201, depending on API design)
      if (response.statusCode == 200 || response.statusCode == 201) {
        String message = response.data['message'];
        if (response.data['status'] == 'success') {
          print('Registration successful: ${response.data}');
          snackbarWidget(context, message, Colors.green);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) =>
                false, // This will remove all previous routes
          );
        } else {
          snackbarWidget(context, message, Colors.amber);
        }
        // Registration successful
      } else {
        // Registration failed
        print('Registration failed: ${response.data['message']}');
        snackbarWidget(context, 'Registration failed', Colors.red);
      }
    } catch (e) {
      print('Error during registration: $e');
      snackbarWidget(context, 'Registration failed', Colors.red);
    }
  }

  // Forgot password function
  Future<bool> sendOtpToMobile(String mobile, context) async {
    try {
      // Prepare data
      Map<String, dynamic> emailData = {
        'phone': mobile,
      };

      // Send a POST request to forgot password endpoint
      Response response = await dio.post(Api.sendotp, data: emailData);

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Password reset email sent successfully.');
        snackbarWidget(context, 'OTP send to Mobile', Colors.black);
        return true;
      } else {
        print('Failed to send reset email: ${response.data['message']}');
        return false;
      }
    } catch (e) {
      print('Error during sending reset email: $e');
      return false;
    }
  }

  // Verify OTP function
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      // Prepare data
      Map<String, dynamic> otpData = {
        'phone': phone,
        'code': otp,
      };

      // Send POST request to verify OTP endpoint
      Response response = await dio.post(Api.verifyOtp, data: otpData);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print('OTP verification successful: ${response.data}');
        return true;
      } else {
        print('OTP verification failed: ${response.data['message']}');
        return false;
      }
    } catch (e) {
      print('Error during OTP verification: $e');
      return false;
    }
  }

// change password
  Future<void> resetPassword(String phone, String newPassword, context) async {
    try {
      // Prepare data for password change
      Map<String, dynamic> passwordData = {
        'phone': '+91$phone',
        'new_password': newPassword,
      };

      // Send POST request to change password endpoint
      Response response =
          await dio.post(Api.forgotPassword, data: passwordData);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print('Password changed successfully');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) =>
              false, // This will remove all previous routes
        );
      } else {
        print('Password change failed: ${response.data['message']}');
      }
    } catch (e) {
      print('Error during password change: $e');
    }
  }

  // logout

  Future<bool> logout(BuildContext context) async {
    String? token = await AuthService
        .getToken(); // Assuming you have a function to get the token

    if (token != null) {
      try {
        // Set Authorization header
        dio.options.headers['Authorization'] = 'Bearer $token';

        // Call logout API (make sure you have a valid API endpoint for logout)
        Response response = await dio.post(
          Api.logout, // Your API endpoint for logout
        );

        if (response.statusCode == 200) {
          // Logout was successful

          // Clear token or any user data locally (e.g., SharedPreferences)
          await AuthService
              .clearToken(); // Assuming you have a function to clear the token

          // Optionally navigate the user to the login screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctxt) => LoginScreen()));

          return true;
        } else {
          // Failed to logout
          print('Failed to logout: ${response.data}');
          return false;
        }
      } catch (e) {
        // Handle error
        print('Error during logout: $e');
        return false;
      }
    } else {
      print('No token found, unable to logout.');
      return false;
    }
  }

  // Example function to clear the token (adjust according to how you're storing the token)
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
