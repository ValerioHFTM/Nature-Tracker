import 'package:flutter/material.dart';

class AppColors {
  static bool isDarkMode = false;

  static Color get color1 =>
      isDarkMode ? const Color(0xFF748E55) : const Color(0xFF111111);
  static Color get color2 =>
      isDarkMode ? const Color(0xFF606060) : const Color(0xFF606060);
  static Color get color3 =>
      isDarkMode ? const Color(0xFF111111) : const Color(0xFFFCFBE8);
  static Color get color4 =>
      isDarkMode ? const Color(0xFFC49120) : const Color(0xFFC49120);
  static Color get color5 =>
      isDarkMode ? const Color(0xFFFCFBE8) : const Color(0xFFC0DC9E);
  static Color get greenColor =>
      isDarkMode ? const Color(0xFF6BBA75) : const Color(0xFF6BBA75);
  static Color get redColor =>
      isDarkMode ? const Color(0xFFE0865E) : const Color(0xFFE0865E);

  static void darkMode(bool status) {
    isDarkMode = status;
  }
}
