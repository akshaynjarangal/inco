import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/utlities/validations.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/data/local/districtList.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController placeController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  // TextEditingController emailController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  ValueNotifier<String?> selectedDistrict = ValueNotifier<String?>(null);

  @override
  void initState() {
    var profile = Provider.of<ProfileProvider>(context, listen: false)
        .currentUserProfileData;

    placeController.text = profile!.place!;
    cityController.text = profile.city!;
    phoneController.text = profile.phone!;
    pincodeController.text = profile.pincode!;
    nameController.text = profile.name!;
    selectedDistrict.value = profile.district;
    super.initState();
  }

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
        title: const Text('Edit Profile',
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
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 23, 22,
                                22)), // Red border when not focused
                      ),
                      labelText: 'District',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: appThemeColor), // Red border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                appThemeColor), // Red border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: appThemeColor), // Red border when focused
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
            SizedBox(
              height: 20,
            ),
            CustomeButton(
              height: 40,
              width: mediaqry.width / 2,
              text: 'change',
              ontap: () async {
                if (formkey.currentState!.validate()) {
                  var provider =
                      Provider.of<ProfileProvider>(context, listen: false);

                  UserModel updatedUser = UserModel(
                      email: '',
                      name: nameController.text,
                      place: placeController.text,
                      city: cityController.text,
                      district: selectedDistrict.value,
                      phone: '',
                      pincode: pincodeController.text);
                  await provider.edituserProfile(updatedUser, context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
