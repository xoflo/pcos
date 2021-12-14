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
import 'package:thepcosprotocol_app/widgets/quiz/question_card.dart';
import 'package:thepcosprotocol_app/widgets/quiz/quiz_intro.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class QuizDisplay extends StatefulWidget {
  final ModulesProvider modulesProvider;
  final Size screenSize;

  QuizDisplay({
    @required this.modulesProvider,
    @required this.screenSize,
  });

  @override
  _QuizDisplayState createState() => _QuizDisplayState();
}

class _QuizDisplayState extends State<QuizDisplay> {
  bool _isLoading = true;
  Quiz _quiz = Quiz();
  int _currentQuestionID = 0;
  int _selectedQuestion = 0;
  bool _displayIntro = true;
  bool _displayQuestions = false;

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  Future<void> _initialise() async {
    Quiz quiz = Quiz();
    if (widget.modulesProvider.lessonQuizzes.length > 0) {
      quiz = widget.modulesProvider.lessonQuizzes[0];
    }
    setState(() {
      _quiz = quiz;
      _currentQuestionID = quiz.questions[0].quizQuestionID;
      _isLoading = false;
    });
  }

  void _hideIntro() async {
    debugPrint("DISPLAY QUESTIONS");
    setState(() {
      _displayIntro = false;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _displayQuestions = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _selectedQuestion = _selectedQuestion + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = widget.screenSize.height - 143;
    final Quiz quiz = widget.modulesProvider.lessonQuizzes[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: _isLoading
          ? PcosLoadingSpinner()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: widget.modulesProvider.lessonQuizzes[0].title,
                  closeItem: () {
                    Navigator.pop(context);
                  },
                  showMessagesIcon: false,
                ),
                SizedBox(
                  height: containerHeight,
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: _displayQuestions ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1000),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: OverflowBox(
                          alignment: Alignment.topCenter,
                          //minHeight: containerHeight,
                          maxHeight: containerHeight * quiz.questions.length,
                          maxWidth: widget.screenSize.width,
                          child: Stack(children: [
                            AnimatedPositioned(
                              top: _selectedQuestion == 0
                                  ? 0
                                  : (containerHeight * _selectedQuestion) * -1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:
                                    quiz.questions.map((QuizQuestion question) {
                                  return QuestionCard(
                                    question: question,
                                    screenSize: widget.screenSize,
                                    next: _nextQuestion,
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      _displayQuestions
                          ? Container()
                          : AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _displayIntro ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 1000),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: SizedBox(
                                width: widget.screenSize.width,
                                child: QuizIntro(
                                    introduction: quiz.description,
                                    hideIntro: _hideIntro),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
