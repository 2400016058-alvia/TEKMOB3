import 'package:flutter/material.dart';
import 'pages/stateless_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Bareng Capybara 🦫',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B8E5A),
        ),
        useMaterial3: true,
      ),
      home: const StatelessPage(),
    );
  }
}