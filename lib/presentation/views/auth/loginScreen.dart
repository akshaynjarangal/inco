import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/utlities/validations.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/presentation/views/auth/forgotPass.dart';
import 'package:inco/presentation/views/auth/registerScreen.dart';
import 'package:inco/service/auth.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ValueNotifier<bool> passwordVisibility = ValueNotifier<bool>(true);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  var formkey = GlobalKey<FormState>();
  Future<void> requestAndroidNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
    requestAndroidNotificationPermission();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: mediaqry.height * 0.2,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      color: appThemeColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mediaqry.height * 0.1,
                ),
                CustomeTextfield(
                  keybordType: TextInputType.emailAddress,
                  prifixicon: Icons.email,
                  label: 'Email or Phone',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone number';
                    }

                    // Regular expression for email validation
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    // Regular expression for phone validation (Assuming 10 digits)
                    final phoneRegex = RegExp(r'^\d{10}$');

                    if (!emailRegex.hasMatch(value) && 
                        !phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid email or phone number';
                    }

                    return null; // Return null if validation is successful
                  },
                ),
                ValueListenableBuilder(    
                  
                  valueListenable: passwordVisibility,
                  builder: (context, value, child) => CustomeTextfield(
                    
                    obsecure: passwordVisibility.value,
                    suffixicon: IconButton(
                        onPressed: () {
                          passwordVisibility.value = !passwordVisibility.value;
                        },
                        icon: Icon(passwordVisibility.value
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    prifixicon: Icons.lock,
                    label: 'Password',
                    controller: passwordController,
                    validator: (value) {
                      // Check if the value is empty
                      if (value == null || value.isEmpty) {
                        return "Enter password";
                      }

                      // if (value.length < 6) {
                      //   return "Password must be at least 6 characters long";
                      // }

                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contxt) => ForgotPasswordScreen()));
                      },
                      child: const Text('Forgot Password?   ')),
                ),
                SizedBox(
                  height: mediaqry.height * 0.03,
                ),
                ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return isLoading.value
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: appThemeColor,
                            ),
                          )
                        : CustomeButton(
                            ontap: () async {
                              if (formkey.currentState!.validate()) {
                                isLoading.value = true;
                                AuthService auth = AuthService();
                                await auth.login(emailController.text,
                                    passwordController.text, context);
                                isLoading.value = false;
                                print('object');
                              }
                            },
                            height: 43,
                            width: mediaqry.width / 2,
                            text: 'Login');
                  },
                ),
                SizedBox(
                  height: mediaqry.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New user?'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: const Text('Sign Up'))
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
