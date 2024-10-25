import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart'; // Assuming you have your appThemeColor defined here
import 'package:inco/core/constent/endpoints.dart';
import 'dart:async';

import 'package:inco/data/local/districtList.dart';
import 'package:inco/data/model/userModel.dart';
import 'package:inco/presentation/views/user/profileScreen.dart';
import 'package:inco/state/profileProvider.dart';
import 'package:inco/state/userProvider.dart';
import 'package:provider/provider.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fetchData(_tabController.index);
      }
    });

    // Fetch all users initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(0); // Load All Users
    });
  }

  Future<void> _fetchData(int tabIndex) async {
    var provider = Provider.of<UserProvider>(context, listen: false);
    if (tabIndex == 0) {
      provider.clearUsers();
      await provider.getAllUsers();
    } else {
      provider.clearUsers();
      await provider.getSuspendedUsers();
    }
    provider.updateTabIndex(tabIndex); // Update tab index in provider
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Users',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Column(
        children: [
          // TabBar for All and Suspended users
          TabBar(
            controller: _tabController,
            dividerColor: Colors.white,
            labelColor: Colors.black, // Color of the selected tab label
            unselectedLabelColor:
                Colors.grey, // Color of the unselected tab label
            indicatorColor: appThemeColor, // Color of the tab indicator
            tabs: const [
              Tab(text: 'All'), // First tab
              Tab(text: 'Suspended '), // Second tab
            ],
          ),
          const SizedBox(height: 10),
          // Filter Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt_outlined),
                onSelected: (String value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateSelectedDistrict(value);
                },
                itemBuilder: (BuildContext context) {
                  List<String> districtOptions = ['All'] + districts;
                  return districtOptions.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                if (provider.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.filteredUsers == null ||
                    provider.filteredUsers!.isEmpty) {
                  return const Center(child: Text('No Users'));
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    buildUserCard(
                        context, provider.filteredUsers!, _tabController.index),
                    buildUserCard(
                        context, provider.filteredUsers!, _tabController.index),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildUserCard(BuildContext context, List<UserModel> users, index) {
  return RefreshIndicator(
    onRefresh: () async {
      var pro = Provider.of<UserProvider>(context, listen: false);
      if (index == 0) {
        await pro.getAllUsers();
      } else {
        await pro.getSuspendedUsers();
      }
    },
    child: ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        UserModel user = users[index];
        return Card(
          child: ListTile(
            onTap: () async {
              Provider.of<ProfileProvider>(context, listen: false)
                  .setuserProfiledata(user);
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctxt) => MyAccountPage(
                          index: index,
                        )),
              );
              // Reload users after returning from account page
              Provider.of<UserProvider>(context, listen: false).getAllUsers();
            },
            leading: CircleAvatar(
              backgroundImage: user.profile != null
                  ? NetworkImage(
                      '${Api.baseUrl}storage/${user.profile!}'
                          .replaceAll('api', ''),
                    )
                  : const AssetImage('assets/images/person.jpg'),
              radius: 30,
            ),
            title: Text(user.name ?? "",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${user.point ?? ""} points',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_sharp, size: 15),
          ),
        );
      },
    ),
  );
}
