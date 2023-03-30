import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:solutionchallenge/models/user.dart' as user_model;
import '../models/place.dart';
import '../models/post models/discount_post.dart';
import '../models/product.dart';

Future<Uint8List?> ppicDownload(var uid) async {

  final documentSnapshot =
  await FirebaseFirestore.instance.collection("User").doc(uid).get();
  final userRecMap = documentSnapshot.data();
  if (userRecMap == null) {
    return null;
  }
  if (userRecMap.containsKey("imageURL")) {
    Uint8List? uint8list =
    await FirebaseStorage.instance.ref(userRecMap["imageURL"]).getData();
    return uint8list;
  }
  return null;
}

Future<Place> getPlace(String cityDocId, String districtDocId) async {
  final cityRef = FirebaseFirestore.instance.doc(cityDocId);
  final districtRef = FirebaseFirestore.instance.doc(districtDocId);

  final results = await Future.wait([
    cityRef.get(),
    districtRef.get(),
  ]);

  final cityData = results[0].data();
  final districtData = results[1].data();

  return Place(
    city: cityData!['name'] ?? '',
    district: districtData!['name'] ?? '',
  );
}

Future<user_model.User> getUser(String ownerDocId) async {
  final ownerRef = FirebaseFirestore.instance.doc(ownerDocId);
  final ownerData = await ownerRef.get();
  return user_model.User(
    id: ownerData.id,
    name: ownerData['name'],
    email: ownerData['email'],

  );
}

Future<Product> getProduct(String productDocId) async {
  final productRef =
  FirebaseFirestore.instance.doc(productDocId);
  final productData = await productRef.get();
  return Product.fromJson(productData.data()!);
}

Future<DiscountPost> getRealPost(DocumentSnapshot postDoc,) async {
  final owner = await getUser(postDoc['ownerRef']);
  final product = await getProduct(postDoc['productRef']);
  String address = postDoc['districtRef'];
  List<String> addressParts = address.split("/");

  final place = await getPlace("/Cities/${addressParts[2]}", postDoc['districtRef']);

  final post = DiscountPost(
      product: product,
      owner: owner,
      place: place,
      id: postDoc.id,
      postdate: postDoc['postdate'].toDate());

  return post;
}

Future<DiscountPost> getRealPostById(String postId) async {
  final DocumentSnapshot<Map<String, dynamic>> postDoc = await FirebaseFirestore.instance
      .collection("DiscountPost")
      .doc(postId)
      .get();
  return getRealPost(postDoc);
}