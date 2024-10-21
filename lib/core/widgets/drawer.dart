import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/adminRedeemedHistoryModel.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/presentation/views/admin/History.dart';
import 'package:inco/presentation/views/admin/manageBanner.dart';
import 'package:inco/presentation/views/user/changePassword.dart';
import 'package:inco/presentation/views/user/helpScreen.dart';
import 'package:inco/service/adminService.dart';
import 'package:inco/service/auth.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:provider/provider.dart';

class CustomeDrawer extends StatelessWidget {
  const CustomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user =
        Provider.of<ProfileProvider>(context).currentUserProfileData;
    return Drawer(
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 232, 230, 230),
            child: AuthService.userType == 'user'
                ? DrawerHeader(
                    child: Row(
                      children: [
                        if (AuthService.userType != 'admin')
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: user!.profile != null
                                ? NetworkImage(
                                    '${Api.baseUrl}storage/${user.profile}'
                                        .replaceAll('api', ''),
                                  )
                                : AssetImage('assets/images/person.jpg'),
                          ),
                        if (AuthService.userType != 'admin')
                          Expanded(
                            child: ListTile(
                              title: Text(user!.name!),
                              subtitle: Text(user.email!),
                            ),
                          ),
                        if (AuthService.userType == 'admin')
                          Expanded(
                            child: ListTile(
                              title: Text(AuthService.adminName!),
                              subtitle: Text(AuthService.adminEmail!),
                            ),
                          ),
                      ],
                    ),
                  )
                : DrawerHeader(
                    child: Container(
                        width: double.maxFinite,
                        child: Center(child: Text('Admin')))),
          ),
          if (AuthService.userType == 'user')
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctxt) => HelpScreen()));
              },
              title: Text('Help'),
              leading: Icon(Icons.help_outline_outlined),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
            ),
          // if admin
          if (AuthService.userType == 'admin')
            Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctxt) => ChangePasswordScreen()));
                  },
                  title: Text('Change Password'),
                  leading: Icon(Icons.lock_open_rounded),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    print('object');
                    await Provider.of<BannerProvider>(context, listen: false)
                        .getBanners();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctxt) => ManegeBannerScreen()));
                  },
                  title: Text('Edit Banner'),
                  leading: Icon(Icons.branding_watermark_rounded),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    AdminService adminService = AdminService();

                    List<AdminRedeemedHistoryModel>? historydata =
                        await adminService.adminRedeemedHistoryView();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctxt) => ProductHistoryScreen(
                                  history: historydata!,
                                )));
                  },
                  title: Text('History'),
                  leading: Icon(Icons.history_toggle_off),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                ),
              ],
            ),
          ListTile(
            onTap: () {
              AuthService auth = AuthService();
              auth.logout(context);
            },
            title: Text('Log Out'),
            leading: Icon(Icons.logout_sharp),
          )
        ],
      ),
    );
  }
}
