// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrackr/screens/colors_util.dart';
import 'package:gymtrackr/screens/signin_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String userName = "User"; // Default user name

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() {
    if (user != null) {
      FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
          if (value.exists) {
            setState(() {
              userName = value.data()?['username'] ?? "User"; // Fallback to "User" if not set
            });
          }
        }).catchError((error) {
          print("Failed to fetch user data: $error");
        });
    }
  }

  String getFormattedDate() {
    return DateFormat('d MMM, yyyy').format(DateTime.now()); // Format the date as "7 May, 2024"
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  // Greetings row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $userName!', // Dynamic date
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),  
                          ),
                          SizedBox(height: 8),
                          Text(
                            getFormattedDate(),
                            style: TextStyle(color: Colors.blue[200]),
                          ),
                        ],
                      ),
                      // Sign out button
                      GestureDetector(
                        onTap: _signOut,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.exit_to_app, // Changed to sign out icon
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  // How was your workout today?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How was your workout today?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                        ),  
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  // 4 different options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Good
                      Column(
                        children: [
                          EmoticonFace(
                            emoticonFace: '😁',
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Good',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      // Bad
                      Column(
                        children: [
                          EmoticonFace(
                            emoticonFace: '😔',
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Bad',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      // Skipped
                      Column(
                        children: [
                          EmoticonFace(
                            emoticonFace: '🤬',
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Skipped',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      // Rest day
                      Column(
                        children: [
                          EmoticonFace(
                            emoticonFace: '😴',
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Rest',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    // Exercise heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Exercises',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                    SizedBox(height: 20),
                    // List view of exercises
                    Expanded(
                      child: ListView(
                        children: [
                          ExerciseTile(
                            icon: Icons.fitness_center,
                            exerciseName: 'Barbell Bench Press',
                            exerciseGroup: 'Chest, Front Delts, Triceps',
                          ),
                          ExerciseTile(
                            icon: Icons.fitness_center,
                            exerciseName: 'Incline Dumbbell Press',
                            exerciseGroup: 'Upper Chest, Front Delts',
                          ),
                          ExerciseTile(
                            icon: Icons.fitness_center,
                            exerciseName: 'Machine Pec Dec Fly',
                            exerciseGroup: 'Chest',
                          ),
                          ExerciseTile(
                            icon: Icons.fitness_center,
                            exerciseName: 'Dumbbell Lateral Raises',
                            exerciseGroup: 'Medial Delt',
                          ),
                          ExerciseTile(
                            icon: Icons.fitness_center,
                            exerciseName: 'Tricep Pushdown',
                            exerciseGroup: 'Medial and Lateral Tricep',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error signing out"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
