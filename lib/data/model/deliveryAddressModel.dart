class DeliveryAddress {
  String? name;
  String? place;
  String? city;
  String? district;
  String? pincode;
  String? phone;

  DeliveryAddress({
   required this.name,
  required  this.place,
   required this.city,
  required  this.district,
  required  this.pincode,
   required this.phone,
  });

  // Factory method to create a DeliveryAddress object from JSON
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      name: json['name'],
      place: json['place'],
      city: json['city'],
      district: json['district'],
      pincode: json['pincode'],
      phone: json['phone'],
    );
  }

  // Method to convert a DeliveryAddress object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'place': place,
      'city': city,
      'district': district,
      'pincode': pincode,
      'phone': phone,
    };
  }
}
