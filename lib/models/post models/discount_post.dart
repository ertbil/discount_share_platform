import 'package:solutionchallenge/models/place.dart';
import 'package:solutionchallenge/models/product.dart';

import '../user.dart';

class DiscountPost {
  Product product;
  User owner;
  Place place;
  String id;
  DateTime postdate;

  DiscountPost({
    required this.product,
    required this.owner,
    required this.place,
    required this.id,
    required this.postdate,

  });

  DiscountPost.fromJson(Map<String, dynamic> json)
      : product = Product.fromJson(json['product']),
        owner = User.fromJson(json['owner']),
        place = Place.fromJson(json['place']),
        id = json['id'] ?? "",
        postdate = DateTime.tryParse(json['postdate']) ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'owner': owner.toJson(),
      'place': place.toJson(),
      'id': id,
    };
  }
}
