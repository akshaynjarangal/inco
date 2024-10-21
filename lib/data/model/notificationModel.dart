import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    String message;
    NotiFication? newNotification;  // Nullable
    List<NotiFication> notifications;

    NotificationModel({
        required this.message,
        this.newNotification,  // Nullable constructor parameter
        required this.notifications,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        message: json["message"],
        newNotification: json["new_notification"] == null 
            ? null 
            : NotiFication.fromJson(json["new_notification"]),  // Handle null case
        notifications: List<NotiFication>.from(json["notifications"].map((x) => NotiFication.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "new_notification": newNotification?.toJson(),  // Use the null-aware operator (?.) 
        "notifications": List<dynamic>.from(notifications.map((x) => x.toJson())),
    };
}

class NotiFication {
    int id;
    int userId;
    String message;
    String image;
    DateTime createdAt;
    DateTime updatedAt;

    NotiFication({
        required this.id,
        required this.userId,
        required this.message,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    factory NotiFication.fromJson(Map<String, dynamic> json) => NotiFication(
        id: json["id"],
        userId: json["user_id"],
        message: json["message"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "message": message,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
