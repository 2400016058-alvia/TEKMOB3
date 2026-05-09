// ============================
// main.dart
// ============================

import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const StudyDropApp());
}

class StudyDropApp extends StatelessWidget {
  const StudyDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyDrop',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6741),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F0E8),
          foregroundColor: Color(0xFF2C3E28),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A6741),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}