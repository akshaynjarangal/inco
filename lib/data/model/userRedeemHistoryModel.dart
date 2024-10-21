// To parse this JSON data, do
//
//     final userRedeemedHistoryModel = userRedeemedHistoryModelFromJson(jsonString);

import 'dart:convert';

List<UserRedeemedHistoryModel> userRedeemedHistoryModelFromJson(String str) =>
    List<UserRedeemedHistoryModel>.from(
        json.decode(str).map((x) => UserRedeemedHistoryModel.fromJson(x)));

String userRedeemedHistoryModelToJson(List<UserRedeemedHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserRedeemedHistoryModel {
  int id;
  String userId;
  String productId;
  String address;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String productInfo;
  String productImage;
  String point;

  UserRedeemedHistoryModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.productInfo,
    required this.productImage,
    required this.point,
  });

  factory UserRedeemedHistoryModel.fromJson(Map<String, dynamic> json) =>
      UserRedeemedHistoryModel(
        id: json["id"],
        userId: json["user_id"].toString(),
        productId: json["product_id"].toString(),
        address: json["address"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productInfo: json["product_info"],
        productImage: json["product_image"],
        point: json["point"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "address": address,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product_info": productInfo,
        "product_image": productImage,
        "point": point,
      };
}
