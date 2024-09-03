import 'package:flutter/material.dart';
import 'package:nature_tracker/screens/splash_screen.dart';
import 'package:nature_tracker/models/app_colors.dart';

void main() {
  runApp(const NatureTracker());
}

class NatureTracker extends StatelessWidget {
  const NatureTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Trash',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily:
            'FrederickaTheGreat', // This sets the default font family for the app
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.color3,
          selectionColor: AppColors.color3.withOpacity(0.5),
          selectionHandleColor: AppColors.color3,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: 'FrederickaTheGreat',
              fontSize: 72.0,
              fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              fontFamily: 'FrederickaTheGreat',
              fontSize: 36.0,
              fontStyle: FontStyle.italic),
          bodyMedium:
              TextStyle(fontFamily: 'FrederickaTheGreat', fontSize: 14.0),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
