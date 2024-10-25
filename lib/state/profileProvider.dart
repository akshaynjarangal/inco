import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/service/auth.dart';
import 'package:inco/service/userScrvice.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _currentUserProfileData;

  // Public getter for _currentUserProfileData
  UserModel? get currentUserProfileData => _currentUserProfileData;

  void changeStatus(status) {
    _currentUserProfileData!.status = status;
    notifyListeners();
  }

  void setuserProfiledata(UserModel profile) {
    _currentUserProfileData = profile;
  }

  Future<void> fetchProfile() async {
    AuthService auth = AuthService();
    _currentUserProfileData = await auth.fetchUserProfile();
    print(currentUserProfileData!.name);
    notifyListeners();
  }

  Future<void> edituserProfile(newData, context) async {
    UserService userService = UserService();
    bool isUpdated = await userService.updateUserProfile(newData);
    if (isUpdated) {
      await fetchProfile(); // Fetch the updated profile after a successful update

      Navigator.pop(context); // Close the edit screen
      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }

  Future<void> editProfileImage(File imageFile) async {
    UserService userService = UserService();
    String? img = await userService.updateProfileImage(
        imageFile, currentUserProfileData!);
    if (img != null) {
      currentUserProfileData!.profile = img;
      notifyListeners();
    }
  }
}
