import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Materi'),
      ),
      body: const Center(
        child: Text(
          'Halaman Review Materi',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}