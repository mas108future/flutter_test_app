import 'package:flutter/material.dart';
import 'package:test_application/screens/create_quiz_screen.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizCreatorScreen(),
      builder: (context, child) {
        return Directionality(
        textDirection: TextDirection.ltr, // Force Left-to-Right globally
        child: child!,
          );
         },
    );
  }
}