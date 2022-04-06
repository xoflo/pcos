import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/widgets/quiz/quiz_display.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

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
