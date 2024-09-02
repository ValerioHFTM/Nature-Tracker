import 'package:flutter/material.dart';
import 'package:nature_tracker/screens/main_screen.dart';
import 'package:nature_tracker/models/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay of 5 seconds and navigate to the MainScreen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  MainScreen(false,"loggedOut")),
      );
    });
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
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.color5), // Change color here
            ),
            const SizedBox(height: 20),
            const Text(
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
