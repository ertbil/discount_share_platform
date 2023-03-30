import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/firebase_getter.dart';
import '../avatar.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  Future<Uint8List?>? _ppicFut;

  @override
  void initState() {
    super.initState();
    _ppicFut = ppicDownload(FirebaseAuth.instance.currentUser!.uid);
  }


  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              XFile? xfile =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (xfile == null) {
                return;
              } else {
                final imagepath = xfile.path;
                final uid = FirebaseAuth.instance.currentUser!.uid;
                final ppicref =
                    FirebaseStorage.instance.ref("imageURL").child("$uid.jpg");
                await ppicref.putFile(File(imagepath));
                await FirebaseFirestore.instance
                    .collection("User")
                    .doc(uid)
                    .update({
                  "imageURL": ppicref.fullPath,
                });
                setState(() {
                  _ppicFut = ppicDownload(FirebaseAuth.instance.currentUser!.uid);
                });
              }
            },
            child: FirebaseAvatar(ppicFut: _ppicFut, radius: 50,nameFut:FirebaseAuth.instance.currentUser!.displayName) ),

          const SizedBox(
            height: 10,
          ),
          Text(
            FirebaseAuth.instance.currentUser!.displayName!,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

