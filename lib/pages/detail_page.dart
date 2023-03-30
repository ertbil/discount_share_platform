import 'package:flutter/material.dart';

import '../components/avatar.dart';
import '../components/buttons.dart';
import '../models/post models/discount_post.dart';
import '../utils/firebase_getter.dart';

class DetailPage extends StatelessWidget {
  final DiscountPost discountPost;

  const DetailPage({required this.discountPost});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/profile",
                                  arguments: discountPost.owner.id);
                            },
                            child: FirebaseAvatar(
                                ppicFut: ppicDownload(discountPost.owner.id),
                                radius: 30,
                                nameFut: discountPost.owner.name)),
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/profile",
                                    arguments: discountPost.owner.id);
                              },
                              child: Text(
                                discountPost.owner.name,
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "${discountPost.place.city} ${discountPost.place.district}",
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      discountPost.product.description,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      height: 300.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://picsum.photos/200/300"),
                          //discountPost.product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                      ),
                      child: Banner(
                          message: "${discountPost.product.discountRate} %",
                          location: BannerLocation.topEnd,

                          color: Colors.red,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  discountPost.product.brand != null
                      ? "${discountPost.product.brand} ${discountPost.product.name} ${discountPost.product.discountRate} % indirim"
                      : discountPost.product.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${discountPost.product.oldPrice} TL",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${discountPost.product.newPrice} TL",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SaverButton(
                    discountPost: discountPost,
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
