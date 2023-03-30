import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solutionchallenge/models/post%20models/discount_post.dart';

class SaverButton extends StatefulWidget {
  final DiscountPost discountPost;

  const SaverButton({
    required this.discountPost,
    super.key,
  });

  @override
  State<SaverButton> createState() => _SaverButtonState();
}

class _SaverButtonState extends State<SaverButton> {
  late Query query;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    query = FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("saved")
        .where("postRef", isEqualTo: "/Posts/${widget.discountPost.id}");
    query.get().then((querySnapshot) {
      setState(() {
        isSaved = querySnapshot.size > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
      ),
      onPressed: () {
        if (!isSaved) {
          FirebaseFirestore.instance
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("saved")
              .add({
            "postRef": "/Posts/${widget.discountPost.id}",
          }).then((documentReference) {
            setState(() {
              isSaved = true;
            });
          });
        } else {
          query.get().then((querySnapshot) {
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.delete().then((value) {
                setState(() {
                  isSaved = false;
                });
              });
            });
          });
        }
      },
    );
  }
}