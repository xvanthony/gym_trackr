import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymtrackr/screens/colors_util.dart';
import 'package:gymtrackr/screens/home_screen.dart';
import 'package:gymtrackr/screens/page_screen.dart';
import 'package:gymtrackr/screens/signup_screen.dart';
import '../reusable_widgets/reusable_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 30, 136, 229),
              Color(0xFF1565C0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/dumbell.png"),
                SizedBox(height: 30),
                reusableTextField("Enter Username", Icons.person_outline, false, _emailTextController),
                SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outlined, true, _passwordTextController),
                SizedBox(height: 20),
                signInSignUpButton(context, true, signInUser),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInUser() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailTextController.text.trim(),
            password: _passwordTextController.text.trim())
        .then((userCredential) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyPageViewScreen()));
    }).catchError((error) {
      String errorMessage;
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'user-disabled':
            errorMessage = 'This user has been disabled.';
            break;
          case 'user-not-found':
            errorMessage = 'No user corresponding to the email address was found.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password provided for that user.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
        }
      } else {
        errorMessage = 'An error occurred. Please check your internet connection and try again.';
      }
      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Container signInSignUpButton(BuildContext context, bool isLogin, VoidCallback onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          primary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
        ),
        child: Text(
          isLogin ? 'LOGIN' : 'SIGN UP',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
