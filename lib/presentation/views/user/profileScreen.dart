import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/presentation/views/user/changePassword.dart';
import 'package:inco/presentation/views/user/editProfile.dart';
import 'package:inco/service/auth.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:inco/state/userProvider.dart';
import 'package:provider/provider.dart';

class MyAccountPage extends StatefulWidget {
  final index;

  const MyAccountPage({super.key, this.index});
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final ImagePicker picker = ImagePicker();

  // @override
  // void initState() {
  //   super.initState();
  //   // Fetch the profile data when the screen loads
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appThemeColor,
        title: Text('My Account',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        centerTitle: true, // Aligns title to center as shown in image
        actions: [
          if (AuthService.userType != 'admin')
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen())).then((_) {
                    // Refetch the profile when returning from the edit screen
                    if (AuthService.userType != 'admin')
                      Provider.of<ProfileProvider>(context, listen: false)
                          .fetchProfile();
                  });
                },
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Consumer<ProfileProvider>(
                  builder: (context, value, child) {
                    if (value.currentUserProfileData == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                value.currentUserProfileData!.profile == null
                                    ? AssetImage('assets/images/person.jpg')
                                    : NetworkImage(
                                        '${Api.baseUrl}storage/${value.currentUserProfileData!.profile!}'
                                            .replaceAll('api', ''),
                                      ),
                          ),
                          if (AuthService.userType != 'admin')
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 18,
                                  child: IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (contexttt) => AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  var imageee =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  if (imageee != null) {
                                                    value.editProfileImage(
                                                        File(imageee.path));
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  child: ListTile(
                                                    leading: Icon(Icons
                                                        .camera_alt_outlined),
                                                    title: Text('Camera'),
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              GestureDetector(
                                                onTap: () async {
                                                  var imageee =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  if (imageee != null) {
                                                    value.editProfileImage(
                                                        File(imageee.path));
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  child: ListTile(
                                                    leading: Icon(Icons
                                                        .image_search_sharp),
                                                    title: Text('Gallery'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  )),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 60),
                Consumer<ProfileProvider>(
                  builder: (context, value, child) {
                    if (value.currentUserProfileData == null) {
                      return Container(); // Return a placeholder if data is null
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          buildInfoRow(
                              'Name    ', value.currentUserProfileData!.name!),
                          Divider(color: Colors.black12, height: 1),
                          buildInfoRow('Email     ',
                              value.currentUserProfileData!.email!),
                          Divider(color: Colors.black12, height: 1),
                          buildInfoRow(
                              'Phone   ', value.currentUserProfileData!.phone!),
                          Divider(color: Colors.black12, height: 1),
                          buildInfoRow('Address ',
                              '${value.currentUserProfileData!.place},${value.currentUserProfileData!.city},${value.currentUserProfileData!.district},'),
                          SizedBox(height: 35),
                          if (AuthService.userType != 'admin')
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctxt) =>
                                            ChangePasswordScreen()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Change Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (AuthService.userType == 'admin')
                            Consumer<UserProvider>(
                              builder: (context, userprovidervalue, child) =>
                                  InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (ctxt) =>
                                  //             ChangePasswordScreen()));
                                  userprovidervalue.toggleStatus(
                                      context,
                                      value.currentUserProfileData!.id,
                                      widget.index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          value.currentUserProfileData!
                                                      .status !=
                                                  'active'
                                              ? 'Activate'
                                              : 'Suspend Account',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        // Icon(Icons.arrow_forward_ios, size: 12),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Adjust width to your preference
            child: Text(
              '$label :',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
