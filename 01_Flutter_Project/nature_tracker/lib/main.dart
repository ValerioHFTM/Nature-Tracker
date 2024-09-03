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
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.color3, // Set cursor color to color1
          selectionColor: AppColors.color3.withOpacity(
              0.5), // Optional: Set selection color to a lighter version of color1
          selectionHandleColor:
              AppColors.color3, // Set selection handle color to color1
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
