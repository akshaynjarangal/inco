import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/service/userScrvice.dart';
import 'package:inco/state/profileProvider.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  TextEditingController passwordController = TextEditingController();
  TextEditingController cinfirmController = TextEditingController();
  TextEditingController oldpassController = TextEditingController();

  var formkey = GlobalKey<FormState>();
  ValueNotifier<String?> selectedDistrict = ValueNotifier<String?>(null);
  ValueNotifier<bool> passwordVisibility = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmpasswordVisibility = ValueNotifier<bool>(true);
  ValueNotifier<bool> oldpasswordVisibility = ValueNotifier<bool>(true);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
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
        title: const Text('Change Password',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: oldpasswordVisibility,
              builder: (context, value, child) => CustomeTextfield(
                obsecure: oldpasswordVisibility.value,
                suffixicon: IconButton(
                    onPressed: () {
                      oldpasswordVisibility.value =
                          !oldpasswordVisibility.value;
                    },
                    icon: Icon(oldpasswordVisibility.value
                        ? Icons.visibility_off
                        : Icons.visibility)),
                prifixicon: Icons.lock,
                label: 'Old Password',
                controller: oldpassController,
                validator: (value) {
                  // Check if the value is empty
                  if (value == null || value.isEmpty) {
                    return "Enter old password";
                  }

                  return null;
                },
              ),
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
            ),
            ValueListenableBuilder(
              valueListenable: confirmpasswordVisibility,
              builder: (context, value, child) => CustomeTextfield(
                obsecure: confirmpasswordVisibility.value,
                suffixicon: IconButton(
                    onPressed: () {
                      confirmpasswordVisibility.value =
                          !confirmpasswordVisibility.value;
                    },
                    icon: Icon(confirmpasswordVisibility.value
                        ? Icons.visibility_off
                        : Icons.visibility)),
                prifixicon: Icons.lock,
                label: 'Confirm Password',
                controller: cinfirmController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter password again";
                  } else if (value.toString() != passwordController.text) {
                    return "enter password again";
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return isLoading.value
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: appThemeColor,
                          ),
                        )
                      : CustomeButton(
                          height: 40,
                          width: mediaqry.width / 2,
                          text: 'change',
                          ontap: () async {
                            if (formkey.currentState!.validate()) {
                              isLoading.value = true;
                              UserService userService = UserService();
                              await userService.changePassword(
                                  oldpassController.text,
                                  passwordController.text,
                                  context);
                              isLoading.value = false;
                            }
                          },
                        );
                })
          ],
        ),
      ),
    );
  }
}
