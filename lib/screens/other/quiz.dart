import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/quiz/quiz_layout.dart';

class QuizScreen extends StatelessWidget {
  static const String id = "quiz_screen";

  @override
  Widget build(BuildContext context) {
    final quiz = ModalRoute.of(context)?.settings.arguments as Quiz?;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: QuizLayout(quiz: quiz),
        ),
      ),
    );
  }
}
