import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutionchallenge/components/text_fields/base_text_formfield.dart';

import '../components/image_pickers.dart';
import '../models/user.dart' as userModel;


//TODO burası yapılacak
class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const ProfilePicSelector(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: BaseTextFormField(
                        hintText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: BaseTextFormField(
                        hintText: "Surname",
                        prefixIcon: const Icon(Icons.person),
                        controller: _surnameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BaseTextFormField(
                    hintText: "Mail",
                    prefixIcon: const Icon(Icons.email),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (!value.isValidEmail()) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BaseTextFormField(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BaseTextFormField(
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock),
                    controller: _passwordConfirmController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);

                              userModel.User user = userModel.User(
                                name:
                                    '${_nameController.text} ${_surnameController.text}',
                                email: _emailController.text,
                                id: FirebaseAuth.instance.currentUser!.uid,
                              );

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .add(user
                                      .toJson()
                                      .cast<String, dynamic>()
                                      .toMap())
                                  .then(
                                      (value) => (value) {
                                            Navigator.of(context)
                                                .pushReplacementNamed('/main');
                                          }, onError: ((error) {
                                // Handle the error here
                                print('Error adding user to Firestore: $error');
                                // Show an error message to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error adding user to Firestore')),
                                );
                              }));
                            }


                            Navigator.of(context).pushNamed('/main');
                          },
                          child: const Text("Sign Up")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Already have account?")),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
