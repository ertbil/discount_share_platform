import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solutionchallenge/components/lists/post_card.dart';

import '../../models/post models/discount_post.dart';
import '../../utils/firebase_getter.dart';

class BaseGrid extends StatelessWidget {
  final String userId;

  const BaseGrid({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postsCollection =
        FirebaseFirestore.instance.collection('DiscountPost');

    final userPostCollection =
        postsCollection.where('ownerRef', isEqualTo: "/User/$userId");
    final userPostQuery = userPostCollection.orderBy('postdate', descending: true);

    return RefreshIndicator(
        onRefresh: () async {},
        child: StreamBuilder<QuerySnapshot>(
          stream: userPostQuery.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DiscountPost>(
                    future: getRealPost(posts[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final post = snapshot.data!;
                        return PostCard(
                          discountPost: post,
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
