import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutionchallenge/components/text_fields/base_text_formfield.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Log In',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: BaseTextFormField(
                        key: const Key('username'),
                        hintText: "Username",
                        prefixIcon: const Icon(Icons.email),
                        controller: usernameController,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (!value.isValidEmail()) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: BaseTextFormField(
                        key: const Key('password'),
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            bool? isValid = formKey.currentState?.validate();
                            if (isValid == true) {
                              // if(isValid) { değil çünkü null olabilir
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: usernameController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  "email":
                                      FirebaseAuth.instance.currentUser!.email,
                                  "isLogged": "true",
                                  "lastLogTime": FieldValue.serverTimestamp(),
                                }, SetOptions(merge: true));

                                FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get()
                                    .then((DocumentSnapshot documentSnapshot) {
                                  if (documentSnapshot.exists) {
                                    String newName =
                                        documentSnapshot.get("name").toString();
                                    FirebaseAuth.instance.currentUser
                                        ?.updateDisplayName(newName)
                                        .then((value) {
                                      // Başarılı güncelleme işlemi
                                    }).catchError((error) {
                                      // Güncelleme hatası
                                    });
                                  }
                                }).catchError((error) {
                                  // Okuma hatası
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/main');
                              }, onError: (error) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(error.toString()),
                                ));
                              });

                              // ref.read(userProvider).login(
                              //     usernameController.text,
                              //     passwordController.text);
                            }
                          },
                          child: const Text('Log In'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
