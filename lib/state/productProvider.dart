import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inco/data/model/adminRedeemedHistoryModel.dart';
import 'package:inco/data/model/deliveryAddressModel.dart';
import 'package:inco/data/model/pointRequestModel.dart';
import 'package:inco/data/model/productModel.dart';
import 'package:inco/data/model/progressCountMode.dart';
import 'package:inco/data/model/userRedeemHistoryModel.dart';
import 'package:inco/service/adminService.dart';
import 'package:inco/service/userScrvice.dart';
import 'package:inco/state/profileProvider.dart';

class ProductProvider extends ChangeNotifier {
  AdminService adminservice = AdminService();
  List<ProductModel>? _productList = [];
  List<ProductModel> get productList => _productList!;
  DeliveryAddress? _deliveryaddress;
  DeliveryAddress? get usedeliveryaddress => _deliveryaddress;

  List<UserRedeemedHistoryModel>? userRedemedHistory = [];

  File? _selectedImage;

  File? get selectedImage => _selectedImage;
  bool isLoading = false;
  bool isDeleting = false;
  int? deletingIndex;
  List<AdminRedeemedHistoryModel>? redeemRequestes = [];
  List<PointRequestesModel>? pointRequestes = [];
  ProgressCountModel? progressdata;

  Future<void> getUserRedeemHistory() async {
    UserService userService = UserService();
    userRedemedHistory = await userService.getUserRedeemedHistory();
    notifyListeners();
  }

  Future<void> getProgressAndCount() async {
    progressdata = await adminservice.getProgressAndCountfun();
    notifyListeners();
  }

  Future<void> acceptRequesst(id) async {
    await adminservice.acceptRequest(id);
    pointRequestes = await adminservice.getPointRequestes();
    notifyListeners();
  }

  Future<void> rejectRequestes(id) async {
    await adminservice.rejectRequest(id);
    pointRequestes = await adminservice.getPointRequestes();
    notifyListeners();
  }

  Future<void> getPointRequestes() async {
    pointRequestes = await adminservice.getPointRequestes();
    notifyListeners();
  }

  Future<void> redeemrequestmarkTOShipped() async {
    redeemRequestes = await adminservice.adminGetRedeemedRequestes();
    notifyListeners();
  }

  // Setter for selected image
  void setdeliveryaddress(address) {
    _deliveryaddress = address;
    notifyListeners();
  }

  void setImage(File image) {
    _selectedImage = image;
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> addProduct(File img, point, info, context) async {
    isLoading = true;
    notifyListeners();
    await adminservice.postDataWithTokenAndImage(
        imageFile: img, point: point, productinfo: info);
    isLoading = false;
    _selectedImage = null;
    notifyListeners();
    await fetchProducts();
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> fetchProducts() async {
    _productList = await adminservice.getProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(id) async {
   
    isDeleting = true;
    notifyListeners();
    await adminservice.deleteProduct(id);
    await fetchProducts();
    isDeleting = false;
    notifyListeners();
  }
}
