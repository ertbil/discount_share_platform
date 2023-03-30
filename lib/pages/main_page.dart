import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/drawer_comps/drawer.dart';
import '../components/dropdown/base_dropdown_button.dart';
import '../components/lists/base_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<String>> getDistricts() async {
      final user = FirebaseAuth.instance.currentUser!;


      final userAddress = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get()
          .then((value) {
        final data = value.data();
        return data != null ? data['addresses'] : "";

      });

      if (userAddress == null) {
        // Eğer kullanıcının adresi yoksa, boş bir liste döndürülür
        return [];
      }

      List<String> addresssParts = userAddress.split('/');
      final districtsCollection = FirebaseFirestore.instance.collection('Cities').doc(addresssParts[2]).collection('Districts');

      final result = await Future.wait([
        districtsCollection.get(),
      ]);
      final districts = result[0].docs.map((e) => e.id).toList();
      return districts;
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "/addpost");
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: FutureBuilder<List<String>>(
                future: getDistricts(),
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    return BaseDropDownButton( //TODO buraya şehrin ismini de ekle
                      items: List.generate(
                        snapshot.data!.length,
                            (index) => DropdownMenuItem(
                          value: snapshot.data![index],
                          child: Text(snapshot.data![index]),
                        ),

                      ),
                      onChanged: (value) {
                        print(value);
                      },
                      hintText: 'Select District',
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const Expanded(
              child: BaseList(path: "Posts"),
            ),
          ],
        ),
      ),
    );
  }
}
