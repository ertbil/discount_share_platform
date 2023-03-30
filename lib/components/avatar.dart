import 'dart:typed_data';

import 'package:flutter/material.dart';

class FirebaseAvatar extends StatelessWidget {
  final Future<Uint8List?>? _ppicFut;
  final String? _nameFut;
  final double _radius;

  const FirebaseAvatar({
    super.key,
    required Future<Uint8List?>? ppicFut,
    required String? nameFut,
    required double radius,
  })  : _ppicFut = ppicFut,
        _radius = radius,
        _nameFut = nameFut;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _ppicFut,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
              radius: _radius, child: const CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          final picInMemory = snapshot.data!;
          return CircleAvatar(
            radius: _radius,
            backgroundImage: MemoryImage(picInMemory),
          );
        } else {
          return CircleAvatar(
            radius: _radius,
            child: Text(
              _nameFut!.characters.first,
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
