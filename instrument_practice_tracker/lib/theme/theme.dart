import 'package:flutter/material.dart';

class AppTheme {
  // Main brand color
  static const primary = Color(0xFF4A6CF7);

  // Light background
  static const background = Color(0xFFF4F4F4);

  // Card background
  static const card = Color(0xFFF0F0F0);

  // Text grey
  static const textSecondary = Colors.grey;

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),

      useMaterial3: true,

      scaffoldBackgroundColor: background,

      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
