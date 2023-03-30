class Place {
  String city;
  String district;

  Place({ required this.city, required this.district});

  Place.fromJson(Map<String, dynamic> json)
      :
        city = json['city'] ?? "",
        district = json['district'] ?? "";

  Map<String, dynamic> toJson() {
    return {

      'city': city,
      'district': district,
    };
  }
}
