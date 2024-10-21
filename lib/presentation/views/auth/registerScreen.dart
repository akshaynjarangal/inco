import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/utlities/validations.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/data/local/districtList.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/presentation/views/auth/loginScreen.dart';
import 'package:inco/presentation/views/auth/otpScreen.dart';
import 'package:inco/service/auth.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  // TextEditingController districtController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  ValueNotifier<String?> selectedDistrict = ValueNotifier<String?>(null);
  ValueNotifier<bool> passwordVisibility = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmpasswordVisibility = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
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
                  height: mediaqry.height * 0.05,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: appThemeColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mediaqry.height * 0.04,
                ),
                CustomeTextfield(
                  label: 'Name',
                  prifixicon: Icons.person,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your name";
                    }
                  },
                ),
                CustomeTextfield(
                  prifixicon: Icons.place,
                  label: 'Place',
                  controller: placeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your place";
                    }
                  },
                ),
                CustomeTextfield(
                  prifixicon: Icons.location_city,
                  label: 'City',
                  controller: cityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your city";
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: selectedDistrict,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 23, 22,
                                    22)), // Red border when not focused
                          ),
                          labelText: 'District',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: appThemeColor), // Red border color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color:
                                    appThemeColor), // Red border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color:
                                    appThemeColor), // Red border when focused
                          ),
                        ),
                        value: value,
                        onChanged: (String? newValue) {
                          selectedDistrict.value =
                              newValue; // Update ValueNotifier when selected
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a district";
                          }
                          return null;
                        },
                        items: districts
                            .map<DropdownMenuItem<String>>((String district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(district),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                CustomeTextfield(
                  keybordType: TextInputType.number,
                  prifixicon: Icons.local_post_office_outlined,
                  label: 'Pin code',
                  controller: pincodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your pin code";
                    } else if (value.toString().length != 6) {
                      return 'invalid pin code';
                    }
                  },
                ),
                CustomeTextfield(
                   pretext: '+91 ',
                  keybordType: TextInputType.number,
                  label: 'Phone',
                  prifixicon: Icons.phone,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your phone";
                    } else if (value.toString().length != 10) {
                      return 'invalid phone Number';
                    }
                  },
                ),
                CustomeTextfield(
                  keybordType: TextInputType.emailAddress,
                  prifixicon: Icons.email,
                  label: 'Email',
                  controller: emailController,
                  validator: validateEmail,
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
                    controller: confirmController,
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
                SizedBox(
                  height: mediaqry.height * 0.03,
                ),
                CustomeButton(
                    ontap: () async {
                      AuthService auth = AuthService();
                      if (formkey.currentState!.validate()) {
                        bool isSend = await auth.sendOtpToMobile(
                            phoneController.text, context);

                        UserModel userdata = UserModel(
                            password: passwordController.text,
                            email: emailController.text,
                            name: nameController.text,
                            place: placeController.text,
                            city: cityController.text,
                            district: selectedDistrict.value,
                            phone: phoneController.text,
                            pincode: pincodeController.text);
                        print('object');

                        // if (isSend) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                      regdata: userdata,
                                      isReg: true,
                                    )));
                        // }
                      }
                    },
                    height: 43,
                    width: mediaqry.width / 2,
                    text: 'Sign up'),
                SizedBox(
                  height: mediaqry.height * 0.05,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text('Back to Login'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
