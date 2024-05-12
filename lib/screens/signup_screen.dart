import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymtrackr/reusable_widgets/reusable_widgets.dart';
import 'package:gymtrackr/screens/colors_util.dart';
import 'package:gymtrackr/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrackr/screens/page_screen.dart'; // Import Firestore

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("ADD8E6"),
              hexStringToColor("0000FF"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField("Enter UserName", Icons.person_outline, false, _userNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email", Icons.person_outline, false, _emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outlined, true, _passwordTextController),
                const SizedBox(height: 20),
                signInSignUpButton(context, false, () {
                  FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: _emailTextController.text.trim(), 
                      password: _passwordTextController.text.trim()
                    )
                    .then((value) {
                      // User created. Now store the additional data in Firestore.
                      FirebaseFirestore.instance
                        .collection('users') // You can name this collection anything
                        .doc(value.user!.uid) // Using the UID as the document ID
                        .set({
                          'username': _userNameTextController.text.trim(),
                          'email': _emailTextController.text.trim()
                        })
                        .then((_) {
                          print("User added to Firestore");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyPageViewScreen()));
                        })
                        .catchError((error) {
                          print("Failed to add user to Firestore: $error");
                        });
                    })
                    .catchError((error) {
                      print("Failed to create user: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to create user: ${error.message}"),
                          backgroundColor: Colors.red,
                        )
                      );
                    });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
