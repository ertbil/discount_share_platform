import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer_header.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserHeader(),
          ListTile(
            leading: const Icon(Icons.person_2_rounded),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pushNamed(context, "/profile",
                  arguments: FirebaseAuth.instance.currentUser!.uid);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, "/login");
              });
            },
          ),
        ],
      ),
    );
  }
}