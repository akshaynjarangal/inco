// To parse this JSON data, do
//
//     final pointRequestesModel = pointRequestesModelFromJson(jsonString);

import 'dart:convert';

List<PointRequestesModel> pointRequestesModelFromJson(String str) =>
    List<PointRequestesModel>.from(
        json.decode(str).map((x) => PointRequestesModel.fromJson(x)));

String pointRequestesModelToJson(List<PointRequestesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PointRequestesModel {
  int complaintId;
  Ant complainant;
  Ant defendant;

  PointRequestesModel({
    required this.complaintId,
    required this.complainant,
    required this.defendant,
  });

  factory PointRequestesModel.fromJson(Map<String, dynamic> json) =>
      PointRequestesModel(
        complaintId: json["complaint_id"],
        complainant: Ant.fromJson(json["complainant"]),
        defendant: Ant.fromJson(json["defendant"]),
      );

  Map<String, dynamic> toJson() => {
        "complaint_id": complaintId,
        "complainant": complainant.toJson(),
        "defendant": defendant.toJson(),
      };
}

class Ant {
  int userId;
  String name;
  String email;
  String phone;
  String? image;

  Ant({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  factory Ant.fromJson(Map<String, dynamic> json) => Ant(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
      };
}
