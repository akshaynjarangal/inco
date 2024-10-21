class AdminRedeemedHistoryModel {
  String? productImage;
  String? productInfo;
  String? address;
  String? id;

  String? name;

  // Constructor
  AdminRedeemedHistoryModel({
    required this.productImage,
    required this.productInfo,
    required this.address,
    required this.id,
    required this.name,
  });

  // Factory method to create an instance of ProductModel from JSON
  factory AdminRedeemedHistoryModel.fromJson(Map<String, dynamic> json) {
    return AdminRedeemedHistoryModel(
      productImage: json['product_image'],
      productInfo: json['product_info'],
      address: json['address'].toString(),
      id: json['id'].toString(),
      name: json['user_name'],
    );
  }

  // Method to convert ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_image': productImage,
      'product_info': productInfo,
      'address': address,
      'id': id,
      'user_name': name,
    };
  }
}
