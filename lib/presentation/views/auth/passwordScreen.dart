import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/service/auth.dart';

class PasswordScreen extends StatelessWidget {
  PasswordScreen({super.key, required this.phone});
  final String phone;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New Password',
                style: TextStyle(
                    color: appThemeColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mediaqry.height * 0.08,
              ),
              CustomeTextfield(
                prifixicon: Icons.lock,
                label: 'New Password',
                controller: passwordController,
                validator: (value) {
                  // Check if the value is empty
                  if (value == null || value.isEmpty) {
                    return "Enter password";
                  }

                  if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }

                  String pattern = r'^(?=.*[A-Z]).+$';
                  RegExp regExp = RegExp(pattern);

                  if (!regExp.hasMatch(value)) {
                    return "Password must contain at least one uppercase letter";
                  }

                  return null;
                },
              ),
              CustomeTextfield(
                prifixicon: Icons.lock,
                label: 'Confirm Password',
                controller: confirmpasswordController,
                validator: (value) {
                  // Check if the value is empty
                  if (value == null || value.isEmpty) {
                    return "Enter confirm password";
                  }

                  if (passwordController.text !=
                      confirmpasswordController.text) {
                    return "Password des\'t match";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: mediaqry.height * 0.05,
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
                                await auth.resetPassword(
                                    phone, passwordController.text, context);
                                print('object');
                                isLoading.value = false;
                              }
                            },
                            height: 43,
                            width: mediaqry.width / 2,
                            text: 'Update');
                  }),
              SizedBox(
                height: mediaqry.height * 0.05,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
