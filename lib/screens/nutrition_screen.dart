// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Ensure this package is included for date formatting

class Food {
  final String name;
  final int calories;
  final int protein;
  final DateTime date;

  Food({required this.name, required this.calories, required this.protein, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'calories': this.calories,
      'protein': this.protein,
      'date': DateFormat('yyyy-MM-dd').format(this.date),
    };
  }

  static Food fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      calories: map['calories'],
      protein: map['protein'],
      date: DateTime.parse(map['date']),
    );
  }
}

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  DateTime selectedDate = DateTime.now();
  List<Food> allFoods = [];

  @override
  void initState() {
    super.initState();
    _loadFoodsForSelectedDate();
  }

  void _loadFoodsForSelectedDate() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      var snapshot = await FirebaseFirestore.instance
          .collection('users/${user.uid}/foods')
          .where('date', isEqualTo: dateString)
          .get();

      setState(() {
        allFoods = snapshot.docs
            .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
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
    _loadFoodsForSelectedDate(); // Ensure this method is called here
  }
}




  void _showAddFoodDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController caloriesController = TextEditingController();
    TextEditingController proteinController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,       // Color for floating action buttons and other primary UI
              onPrimary: Colors.white,    // Color for text and icons on primary color
              surface: Colors.white,      // Background color for cards, sheets, and menus
              onSurface: Colors.black,    // Typically the text color on surface colors
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
            title: Text('Add New Food', style: TextStyle(color: Colors.blue)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Food Name'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Calories'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: proteinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Protein (grams)'),
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
                  int? calories = int.tryParse(caloriesController.text);
                  int? protein = int.tryParse(proteinController.text);
                  if (nameController.text.isNotEmpty && calories != null && protein != null) {
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance.collection('users/${user.uid}/foods')
                        .add({
                          'name': nameController.text,
                          'calories': calories,
                          'protein': protein,
                          'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                        });
                      Navigator.of(context).pop();
                      _loadFoodsForSelectedDate();
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
        title: Text('Nutrition Tracker', style: TextStyle(color: Colors.white)),
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
                itemCount: allFoods.length,
                itemBuilder: (context, index) {
                  final food = allFoods[index];
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
                            Icon(Icons.fastfood),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(height: 5),
                                Text('Calories: ${food.calories}, Protein: ${food.protein}g', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
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
              onPressed: _showAddFoodDialog,
              child: Text('Add Food'),
            ),
          ),
        ],
      ),
    );
  }
}
