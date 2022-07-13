import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';

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
  List<QuizAnswer> answers = [];

  bool isAnswerChecked = false;
  bool? isCorrect;

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
            .toList() ??
        [];

    final intersection =
        answers.toSet().intersection(correctAnswers.toSet()).length;

    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect == true
                ? "Correct!"
                : "Whoops! Missed ${correctAnswers.length - intersection} correct answer",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          if (widget.question?.response?.isNotEmpty == true) ...[
            SizedBox(height: 10),
            HtmlWidget(
              widget.question?.response ?? "",
              textStyle: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.question?.questionText ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              SizedBox(height: 15),
              ...generateChoices(),
              if (isAnswerChecked) ...[
                generateResponse(),
                SizedBox(height: 25),
              ] else
                SizedBox(height: 10),
              FilledButton(
                onPressed: answers.isEmpty
                    ? null
                    : () {
                        if (!isAnswerChecked) {
                          final correctAnswers = widget.question?.answers
                              ?.where((answer) => answer.isCorrect == true)
                              .toList();
                          setState(() {
                            isCorrect = listEquals(correctAnswers, answers);
                            isAnswerChecked = true;
                          });
                        } else {
                          widget.onPressNext.call();
                        }
                      },
                text: !isAnswerChecked ? "CHECK ANSWERS" : "NEXT",
                margin: EdgeInsets.zero,
                foregroundColor: Colors.white,
                backgroundColor: backgroundColor,
              ),
            ],
          ),
        ),
      );
}
