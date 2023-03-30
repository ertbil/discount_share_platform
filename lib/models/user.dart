import 'package:solutionchallenge/models/post%20models/discount_post.dart';

class User {
  final String name;
  final String email;
  final String? image;
  final String id;
  final List<DiscountPost>? discountPosts;
  final List<DiscountPost>? savedDiscountPosts;
  final List<User>? followers;
  final List<User>? following;


  User({
    required this.name,
    required this.email,
    required this.id,
    this.image,
    this.discountPosts = const [],
    this.savedDiscountPosts = const [],
    this.followers = const [],
    this.following = const [],

  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? "",
        email = json['email'] ?? "",
        id = json['id'] ?? "",
        image = json['image'] ?? "",
        discountPosts = json['discountPosts'] ?? [],
        savedDiscountPosts = json['savedDiscountPosts'] ?? [],
        followers = json['followers'] ?? [],
        following = json['following'] ?? [];

  toJson() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'image': image,
      'discountPosts': discountPosts,
      'savedDiscountPosts': savedDiscountPosts,
      'followers': followers,
      'following': following,
    };
  }
}
