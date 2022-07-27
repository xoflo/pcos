import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/quiz/quiz_question_item_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

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
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              title: "Quiz",
              closeItem: () => Navigator.pop(context),
              questionNumber: questionNumber + 1,
              questionCount: widget.quiz?.questions?.length,
            ),
            Consumer<ModulesProvider>(
              builder: (context, modulesProvider, child) {
                switch (modulesProvider.status) {
                  case LoadingStatus.empty:
                    return NoResults(message: "Quiz not available");
                  case LoadingStatus.loading:
                    return PcosLoadingSpinner();
                  case LoadingStatus.success:
                    return Expanded(
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
                    );
                }
              },
            ),
          ],
        ),
      );
}
