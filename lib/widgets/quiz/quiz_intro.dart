import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class QuizIntro extends StatelessWidget {
  final String? introduction;
  final Function hideIntro;

  QuizIntro({
    required this.introduction,
    required this.hideIntro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
          ),
          ColorButton(
            isUpdating: false,
            label: S.current.startQuiz,
            onTap: hideIntro,
            width: 250,
          ),
        ]);
  }
}
