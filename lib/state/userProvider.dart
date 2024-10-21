import 'package:flutter/foundation.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/service/adminService.dart';
import 'package:inco/service/userScrvice.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  UserService userService = UserService();
  AdminService adminService = AdminService();

  List<UserModel>? allUsers = [];
  List<UserModel>? suspendedUsers = [];
  List<UserModel>? filteredUsers = [];

  String? selectedDistrict = 'All';

  bool loading = false;

  void toggleStatus(context, userId,index) async {
    print('toggling');
    String? status = await userService.suspendAndActivate(userId, context);
    Provider.of<ProfileProvider>(context, listen: false).changeStatus(status);
    // await getAllUsers(); // Refresh the list after status change
    suspendedUsers!.removeAt(index);
    notifyListeners();
  }

  void clearUsers() {
    allUsers?.clear();
    suspendedUsers?.clear();
  }

  // Fetch all users and apply filter
  Future<void> getAllUsers() async {
    loading = true;
    notifyListeners();
    allUsers = await adminService.getAllUsersfun();
    loading = false;
    filterUsers(); // Apply filtering after data fetch
  }

  // Fetch suspended users and apply filter
  Future<void> getSuspendedUsers() async {
    loading = true;
    notifyListeners();
    suspendedUsers = await adminService.getSuspendedUsersfun();
    loading = false;
    filterUsers(); // Apply filtering after data fetch
  }

  // Filter users based on selected district
  void filterUsers() {
    List<UserModel>? usersToFilter = selectedDistrict == 'All'
        ? (_tabIndex == 0 ? allUsers : suspendedUsers)
        : (_tabIndex == 0
            ? allUsers
                ?.where((user) => user.district == selectedDistrict)
                .toList()
            : suspendedUsers
                ?.where((user) => user.district == selectedDistrict)
                .toList());

    filteredUsers = usersToFilter;
    notifyListeners();
  }

  // Update the selected district and re-filter
  void updateSelectedDistrict(String district) {
    selectedDistrict = district;
    filterUsers();
  }

  // Save current tab index (All = 0, Suspended = 1)
  int _tabIndex = 0;

  void updateTabIndex(int index) {
    _tabIndex = index;
    filterUsers();
  }
}
