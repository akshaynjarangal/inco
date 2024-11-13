// To parse this JSON data, do
//
//     final progressCountModel = progressCountModelFromJson(jsonString);

import 'dart:convert';

ProgressCountModel progressCountModelFromJson(String str) =>
    ProgressCountModel.fromJson(json.decode(str));

String progressCountModelToJson(ProgressCountModel data) =>
    json.encode(data.toJson());

class ProgressCountModel {
  List<ProductPercentage> productPercentages;
  int redeemedRequests;
  int activeUsers;
  int products;
  int complaints;

  ProgressCountModel({
    required this.productPercentages,
    required this.redeemedRequests,
    required this.activeUsers,
    required this.products,
    required this.complaints,
  });

  factory ProgressCountModel.fromJson(Map<String, dynamic> json) =>
      ProgressCountModel(
        productPercentages: List<ProductPercentage>.from(
            json["product_percentages"]
                .map((x) => ProductPercentage.fromJson(x))),
        redeemedRequests: json["redeemedRequests"],
        activeUsers: json["activeUsers"],
        products: json["products"],
        complaints: json["complaints"],
      );

  Map<String, dynamic> toJson() => {
        "product_percentages":
            List<dynamic>.from(productPercentages.map((x) => x.toJson())),
        "redeemedRequests": redeemedRequests,
        "activeUsers": activeUsers,
        "products": products,
        "complaints": complaints,
      };
}

class ProductPercentage {
  int productId;
  String productInfo;
  String productImage;
  double percentage;

  ProductPercentage({
    required this.productId,
    required this.productInfo,
    required this.productImage,
    required this.percentage,
  });

  factory ProductPercentage.fromJson(Map<String, dynamic> json) =>
      ProductPercentage(
        productId: json["product_id"],
        productInfo: json["product_info"],
        productImage: json["product_image"],
        percentage: double.parse(json["percentage"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_info": productInfo,
        "product_image": productImage,
        "percentage": percentage,
      };
}
