import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/quiz/quiz_layout.dart';

class QuizScreen extends StatelessWidget {
  static const String id = "quiz_screen";

  @override
  Widget build(BuildContext context) {
    final quiz = ModalRoute.of(context)?.settings.arguments as Quiz?;
    return Scaffold(
      backgroundColor: primaryColor,
      body: QuizLayout(quiz: quiz),
    );
  }
}
