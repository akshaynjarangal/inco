import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/data/model/bannerModel.dart';
import 'package:inco/data/model/notificationModel.dart';
import 'package:inco/service/bannerScrvice.dart';
import 'package:inco/state/profileProvider.dart';

class BannerProvider extends ChangeNotifier {
  BannerService bannerService = BannerService();

  List<BannerModel>? bannerDatas = [];
  List<String> bannerImages = [];
  String? userTotalPoint;
  List<NotiFication>? notificationList = [];

  Future<void> getNotifications(bool isSend) async {
    notificationList = await bannerService.getNotificationfun(isSend);
    notifyListeners();
  }

  Future<void> getUserTotalPoint() async {
    userTotalPoint = await userService.getPointofUser();
    notifyListeners();
  }

  Future<void> getBanners() async {
    bannerDatas = await bannerService.getBannersfun();
    notifyListeners();
    bannerImages.clear();
    for (BannerModel item in bannerDatas!) {
      bannerImages.add(
          '${Api.baseUrl}storage/${item.bannerImage}'.replaceAll('api', ''));
    }
    notifyListeners();
  }

  Future<void> addBannerfun(File img) async {
    await bannerService.addBanner(img);
    await getBanners();
  }

  Future<void> deleteBannerfun(id) async {
    await bannerService.deleteBannersfun(id);
    await getBanners();
  }

  Future<void> editBannerfun(File img, id) async {
    await bannerService.editBanner(img, id);
    await getBanners();
  }
}
