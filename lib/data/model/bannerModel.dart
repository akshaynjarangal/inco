// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) => List<BannerModel>.from(json.decode(str).map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerModel {
    int id;
    String bannerImage;
    DateTime createdAt;
    DateTime updatedAt;

    BannerModel({
        required this.id,
        required this.bannerImage,
        required this.createdAt,
        required this.updatedAt,
    });

    factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        bannerImage: json["banner_image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "banner_image": bannerImage,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
