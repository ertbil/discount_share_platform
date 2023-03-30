import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solutionchallenge/models/post%20models/discount_post.dart';

import '../../utils/firebase_getter.dart';
import 'post_card.dart';

class BaseList extends StatelessWidget {
  final path;
  const BaseList({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postsCollection = FirebaseFirestore.instance.collection(path);
    final postsQuery = postsCollection.orderBy('postdate', descending: true);

    return RefreshIndicator(
      onRefresh: () async {},
      child: StreamBuilder<QuerySnapshot>(
        stream: postsQuery.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final posts = snapshot.data?.docs ??
                []; //TODO hepsini aynı anda almak yerine sayfalama yapılacak

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder<DiscountPost>(
                  future: getRealPost(posts[index]),
                  builder: (BuildContext context,
                      AsyncSnapshot<DiscountPost> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final post = snapshot.data;
                      return PostCard(
                        discountPost: post!,
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
