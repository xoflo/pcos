import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/widgets/quiz/quiz_display.dart';

class QuizLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Consumer<ModulesProvider>(
        builder: (context, model, child) => QuizDisplay(
          modulesProvider: model,
          screenSize: screenSize,
        ),
      ),
    );
  }
}
