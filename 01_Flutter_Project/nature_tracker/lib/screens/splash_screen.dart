import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nature_tracker/backend/blog_service.dart';
import 'dart:convert';

import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/adventure.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:nature_tracker/models/user_data.dart';
import 'package:nature_tracker/models/user_manager.dart';

import 'package:nature_tracker/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Initialize data asynchronously
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      // Fetch adventures and blogs
      await getAdventures();
      await getBlogs();

      // Fetch and update users
      final users = await getUsers(); // Await the result here
      for (var user in users) {
        UserManager.instance.addUser(user);
      }

      // Navigate to the main screen after a delay
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const MainScreen(false, "loggedOut")),
        );
      });
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      print('Failed to initialize data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/Logo_Black_NatureTracker_Double.png',
              height: 350.0, // Adjust size as needed
              width: 350.0, // Adjust size as needed
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.color5), // Change color here
            ),
            const SizedBox(height: 20),
            Text(
              'Verbindung wird hergestellt...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.color5, // Use color3 for text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
