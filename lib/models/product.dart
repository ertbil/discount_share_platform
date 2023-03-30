class Product {
  final String id;
  final String name;
  final String description;
  final double newPrice;
  final double oldPrice;
  final String imageUrl;
  final String? brand;
  late final double discountRate;

  Product(
      {required this.id,
      required this.name,
      required this.newPrice,
      required this.oldPrice,
      required this.imageUrl,
      required this.description,
      this.brand,
      required this.discountRate});

  double calculateDiscountRate() {
    return (1 - newPrice / oldPrice) * 100;
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        name = json['name'] ?? "",
       // newPrice = double.parse(json['newPrice']) ?? 0.0,
       // oldPrice = double.parse(json['oldPrice']) ?? 0.0,
        newPrice = json['newPrice']?.toDouble() ?? 0.0,
        oldPrice = json['oldPrice']?.toDouble() ?? 0.0,
        imageUrl = json['photoUrl'] ?? "",
        description = json['description'] ?? "",
        brand = json['brand'] {
    discountRate = double.parse(calculateDiscountRate().toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'brand': brand,
      'discountRate': discountRate,
    };
  }
}
