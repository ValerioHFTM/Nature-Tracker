import 'package:flutter/material.dart';
import 'package:smart_trash/splash_screen.dart';

void main() {
  runApp(SmartTrashApp());
}

class SmartTrashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Trash',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}
