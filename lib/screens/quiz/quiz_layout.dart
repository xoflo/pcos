import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/quiz/quiz_question_item_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class QuizLayout extends StatefulWidget {
  const QuizLayout({Key? key, this.quiz}) : super(key: key);

  final Quiz? quiz;

  @override
  State<QuizLayout> createState() => _QuizLayoutState();
}

class _QuizLayoutState extends State<QuizLayout> {
  PageController controller = PageController();
  int questionNumber = 0;

  Widget getQuestionItemComponent(int index, ModulesProvider modulesProvider) {
    final question = widget.quiz?.questions?[index];

    return QuizQuestionItemComponent(
      question: question,
      onPressNext: () async {
        if (questionNumber + 1 < (widget.quiz?.questions?.length ?? 0)) {
          controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
          setState(() => questionNumber += 1);
        } else {
          await modulesProvider
              .setTaskAsComplete(widget.quiz?.quizID, forceRefresh: true)
              .then((value) {
            Navigator.pop(context);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final modulesProvider = Provider.of<ModulesProvider>(context);
    return WillPopScope(
      onWillPop: () async =>
          !Platform.isIOS &&
          modulesProvider.loadingStatus != LoadingStatus.loading,
      child: LoaderOverlay(
        loadingStatusNotifier: modulesProvider,
        emptyMessage: "Quiz not available",
        indicatorPosition: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Header(
                        title: "Quiz",
                        closeItem: () => Navigator.pop(context),
                        questionNumber: questionNumber + 1,
                        questionCount: widget.quiz?.questions?.length,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        child: PageView.builder(
                          controller: controller,
                          itemCount: widget.quiz?.questions?.length,
                          physics: NeverScrollableScrollPhysics(),
                          pageSnapping: true,
                          itemBuilder: (context, index) =>
                              getQuestionItemComponent(index, modulesProvider),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
