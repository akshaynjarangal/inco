class UserModel {
  String? email;
  String? password;
  String? name;
  String? place;
  String? city;
  String? district;
  String? phone;
  String? pincode;
  String? profile;
  String? status;
  String? id;
  String? point;

  // Constructor
  UserModel({
    required this.email,
    this.password,
    required this.name,
    required this.place,
    required this.city,
    required this.district,
    required this.phone,
    required this.pincode,
    this.profile,
    this.status,
    this.id,
    this.point,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        password: json['password'],
        name: json['name'],
        place: json['place'],
        city: json['city'],
        district: json['district'],
        phone: json['phone'],
        pincode: json['pincode'],
        profile: json['profile'],
        status: json['status'],
        id: json['id'].toString(),
        point: json['point'].toString());
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'place': place,
      'city': city,
      'district': district,
      'phone': phone,
      'pincode': pincode,
      'profile': profile,
      'status': status,
      'id': id,
      'point': id
    };
  }
}
