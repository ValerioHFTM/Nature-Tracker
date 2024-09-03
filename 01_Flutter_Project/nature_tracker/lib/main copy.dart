import 'package:flutter/material.dart';
import 'package:nature_tracker/screens/splash_screen.dart';
import 'package:nature_tracker/models/app_colors.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NatureTracker());
}

class NatureTracker extends StatefulWidget {
  const NatureTracker({super.key});

  @override
  State<NatureTracker> createState() => _NatureTrackerState();
}

class _NatureTrackerState extends State<NatureTracker> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Smart Trash',
            theme: ThemeData(
              primarySwatch: Colors.green,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.color1, // Set cursor color to color1
                selectionColor: AppColors.color1.withOpacity(
                    0.5), // Optional: Set selection color to a lighter version of color1
                selectionHandleColor:
                    AppColors.color1, // Set selection handle color to color1
              ),
            ),
            home: const SplashScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'Smart Trash',
          theme: ThemeData(
            primarySwatch: Colors.green,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.color1, // Set cursor color to color1
              selectionColor: AppColors.color1.withOpacity(
                  0.5), // Optional: Set selection color to a lighter version of color1
              selectionHandleColor:
                  AppColors.color1, // Set selection handle color to color1
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
