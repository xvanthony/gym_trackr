// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_this, library_private_types_in_public_api, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Exercise {
  final String name;
  final int weight;
  final int reps;
  final DateTime date;

  Exercise({
    required this.name, 
    required this.weight, 
    required this.reps, 
    required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'weight': this.weight,
      'reps': this.reps,
      'date': this.date.toIso8601String(),
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      weight: map['weight'],
      reps: map['reps'],
      date: DateTime.parse(map['date']),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  DateTime selectedDate = DateTime.now();
  List<Exercise> allExercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercisesForSelectedDate();
  }

  void _loadExercisesForSelectedDate() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      var snapshot = await FirebaseFirestore.instance
          .collection('users/${user.uid}/exercises')
          .where('date', isEqualTo: dateString)
          .get();

      setState(() {
        allExercises = snapshot.docs
            .map((doc) => Exercise.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue, // Header background color
            onPrimary: Colors.white, // Header text color
            surface: Colors.white, // Background color of the picker
            onSurface: Colors.black, // Text color in the picker
          ),
          dialogBackgroundColor: Colors.white, // Background color of the dialog
        ),
        child: child!,
      );
    },
  );
  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked;
    });
    _loadExercisesForSelectedDate(); // Ensure this method is called here
  }
}



  void _showAddExerciseDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController repsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,       // Header background color
              onPrimary: Colors.white,    // Header text color
              surface: Colors.white,      // Background color for the body of dialogs
              onSurface: Colors.black,    // Text color in the body
            ),
            dialogBackgroundColor: Colors.white, // Background color of the dialog
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
              labelStyle: TextStyle(color: Colors.blue), // Style for the label text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.blue, // Color for TextButton text
              ),
            ),
          ),
          child: AlertDialog(
            title: Text('Add New Exercise', style: TextStyle(color: Colors.blue)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Exercise Name'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Weight (lbs)'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Reps'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () async {
                  int? weight = int.tryParse(weightController.text);
                  int? reps = int.tryParse(repsController.text);
                  if (nameController.text.isNotEmpty && weight != null && reps != null) {
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance.collection('users/${user.uid}/exercises')
                        .add({
                          'name': nameController.text,
                          'weight': weight,
                          'reps': reps,
                          'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                        });
                      Navigator.of(context).pop();
                      _loadExercisesForSelectedDate();
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Exercise List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ListView.builder(
                itemCount: allExercises.length,
                itemBuilder: (context, index) {
                  final exercise = allExercises[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.fitness_center),  // Default icon for all exercises
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exercise.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(height: 5),
                                Text('Weight: ${exercise.weight} lbs, Reps: ${exercise.reps}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.blue[800],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[900],
                onPrimary: Colors.white,
              ),
              onPressed: _showAddExerciseDialog,
              child: Text('Add Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}
