import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gymtrackr/screens/home_screen.dart';
import 'package:gymtrackr/screens/nutrition_screen.dart';
import 'package:gymtrackr/screens/workout_screen.dart';

class MyPageViewScreen extends StatefulWidget {
  @override
  _MyPageViewScreenState createState() => _MyPageViewScreenState();
}

class _MyPageViewScreenState extends State<MyPageViewScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;  // Add a state variable to track selected index

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected index
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomeScreen(),
          WorkoutScreen(),
          NutritionScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;  // Update the selected index when page changes
          });
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            backgroundColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
            gap: 8,
            selectedIndex: _selectedIndex,  // Ensure this is used to sync tab selection
            onTabChange: _onTabChange,  // Connect your method here
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.fitness_center,
                text: 'Workout',
              ),
              GButton(
                icon: Icons.kitchen,
                text: 'Nutrition',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Don't forget to dispose of the controller!
    super.dispose();
  }
}
