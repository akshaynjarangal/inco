class ProductModel {
  String? productImage;
  String? productInfo;
  String? point;
  String? id;

  // Constructor
  ProductModel({
    this.productImage,
    this.productInfo,
    this.point,
    this.id,
  });

  // Factory method to create an instance of ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        productImage: json['product_image'],
        productInfo: json['product_info'],
        point: json['point'].toString(),
        id: json['id'].toString());
  }

  // Method to convert ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_image': productImage,
      'product_info': productInfo,
      'point': point,
      'id': id
    };
  }
}
