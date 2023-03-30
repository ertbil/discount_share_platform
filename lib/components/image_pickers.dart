
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicSelector extends StatefulWidget {
  const ProfilePicSelector({Key? key}) : super(key: key);

  @override
  _ProfilePicSelectorState createState() => _ProfilePicSelectorState();
}

class _ProfilePicSelectorState extends State<ProfilePicSelector> {
  Future<Uint8List?>? _ppicFut;

  Future<void> _selectProfilePicture(ImageSource source) async {
    final XFile? xfile = await ImagePicker().pickImage(source: source);
    if (xfile == null) {
      return;
    }

    final imageFile = File(xfile.path);



    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ppicref = FirebaseStorage.instance.ref("ppic").child("$uid.jpg");
    await ppicref.putFile(imageFile as File);
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "ppicref": ppicref.fullPath,
    });

    setState(() {
      _ppicFut = _ppicDownload();
    });
  }

  Future<Uint8List?> _ppicDownload() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final documentSnapshot =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final userRecMap = documentSnapshot.data();
    if (userRecMap == null) {
      return null;
    }
    if (userRecMap.containsKey("ppicref")) {
      final Uint8List? uint8list =
      await FirebaseStorage.instance.ref(userRecMap["ppicref"]).getData();
      return uint8list;
    }
  }

  @override
  void initState() {
    super.initState();
    _ppicFut = _ppicDownload();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Choose from gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _selectProfilePicture(ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a picture'),
                    onTap: () {
                      Navigator.pop(context);
                      _selectProfilePicture(ImageSource.camera);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: FutureBuilder<Uint8List?>(
        future: _ppicFut,
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          final ppic = snapshot.data;
          return CircleAvatar(
            radius: 50,
            backgroundImage: ppic != null ? MemoryImage(ppic) : null,
            child: ppic == null
                ? const Icon(
              Icons.add_photo_alternate_rounded,
              size: 50,
            )
                : null,
          );
        },
      ),
    );
  }
}