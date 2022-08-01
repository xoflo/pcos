import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';
import 'package:intl/intl.dart';

class QuizQuestionItemComponent extends StatefulWidget {
  const QuizQuestionItemComponent(
      {Key? key, required this.question, required this.onPressNext})
      : super(key: key);

  final QuizQuestion? question;
  final Function() onPressNext;

  @override
  State<QuizQuestionItemComponent> createState() =>
      _QuizQuestionItemComponentState();
}

class _QuizQuestionItemComponentState extends State<QuizQuestionItemComponent> {
  Set<QuizAnswer> answers = {};

  bool isAnswerChecked = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    isAnswerChecked = widget.question?.answers?.length == 0;
  }

  List<Widget> generateChoices() {
    return widget.question?.answers?.map((answer) {
          final answerColor = isCorrect == null
              ? backgroundColor
              : (isCorrect == false ? redColor : completedBackgroundColor);
          return Column(
            children: [
              HollowButton(
                onPressed: isAnswerChecked
                    ? null
                    : () {
                        if (widget.question?.isMultiChoice == true) {
                          setState(() {
                            if (!answers.contains(answer)) {
                              answers.add(answer);
                            } else {
                              answers.remove(answer);
                            }
                          });
                        } else {
                          setState(() {
                            if (!answers.contains(answer)) {
                              answers.clear();
                              answers.add(answer);
                            } else {
                              answers.remove(answer);
                            }
                          });
                        }
                      },
                verticalPadding: 7.5,
                text: answer.answerText ?? "",
                style: OutlinedButton.styleFrom(
                  onSurface: answers.contains(answer)
                      ? answerColor
                      : textColor.withOpacity(0.8),
                  primary: backgroundColor,
                  backgroundColor: primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: answers.contains(answer)
                      ? BorderSide(
                          width: 2,
                          color: answerColor,
                        )
                      : null,
                ),
                margin: EdgeInsets.zero,
                textAlignment: Alignment.centerLeft,
              ),
              SizedBox(height: 15),
            ],
          );
        }).toList() ??
        [];
  }

  Widget generateResponse() {
    final titleColor = isCorrect == true ? backgroundColor : redColor;

    final correctAnswers = widget.question?.answers
            ?.where((element) => element.isCorrect == true)
            .toSet() ??
        {};

    final intersection = answers.intersection(correctAnswers).length;

    final missedAnswers = correctAnswers.length - intersection;

    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            missedAnswers == 0
                ? "Correct!"
                : "Whoops! Missed $missedAnswers correct ${Intl.plural(missedAnswers, one: 'answer', other: 'answers')}",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: titleColor),
          ),
          if (widget.question?.response?.isNotEmpty == true) ...[
            SizedBox(height: 10),
            HtmlWidget(
              widget.question?.response ?? "",
              textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: textColor.withOpacity(0.8)),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMultiChoice = widget.question?.isMultiChoice == true;
    final answerCount = widget.question?.answers?.length;
    final corrects = widget.question?.answers
        ?.where((element) => element.isCorrect == true)
        .length;
    final selectedAnswers = answers.length;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.question?.questionText ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline4,
            ),
            if (isMultiChoice) ...[
              SizedBox(height: 10),
              Text(
                "(Choose $corrects answers)",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: textColor.withOpacity(0.8)),
              )
            ],
            SizedBox(height: 15),
            ...generateChoices(),
            if (isAnswerChecked && answerCount != 0) ...[
              generateResponse(),
              SizedBox(height: 25),
            ] else
              SizedBox(height: 10),
            FilledButton(
              onPressed: answers.length != corrects && corrects != 0
                  ? null
                  : () {
                      if (!isAnswerChecked) {
                        final correctAnswers = widget.question?.answers
                            ?.where((answer) => answer.isCorrect == true)
                            .toSet();
                        setState(() {
                          isCorrect = setEquals(correctAnswers, answers);
                          isAnswerChecked = true;
                        });
                      } else {
                        widget.onPressNext.call();
                      }
                    },
              text: !isAnswerChecked
                  ? "CHECK ANSWERS${isMultiChoice ? " ($selectedAnswers/$corrects)" : ''}"
                  : "NEXT",
              margin: EdgeInsets.zero,
              foregroundColor: Colors.white,
              backgroundColor: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
