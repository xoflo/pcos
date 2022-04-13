import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final Size screenSize;
  final bool isFinalQuestion;
  final bool isFinalCard;
  final Function(bool) next;

  QuestionCard({
    required this.question,
    required this.screenSize,
    required this.isFinalQuestion,
    required this.isFinalCard,
    required this.next,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _isLoading = true;
  bool _radioSelectedValueCorrect = false;
  int _radioSelectedValue = 0;
  String _radioSelectedResponse = "";
  bool _memberHasInteracted = false;
  bool _isAnswered = false;
  List<bool> _actualAnswers = [];
  List<bool> _memberAnswers = [];

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  Future<void> _initialise() async {
    for (QuizAnswer answer in widget.question.answers ?? []) {
      _actualAnswers.add(answer.isCorrect ?? false);
      _memberAnswers.add(false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _getMultiChoiceAnswers() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          S.current.quizMulti,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      Column(
          children: widget.question.answers
                  ?.asMap()
                  .map((index, answer) => MapEntry(
                      index,
                      CheckboxListTile(
                        title: Text(answer.answerText ?? ""),
                        value: _memberAnswers[index],
                        onChanged: (bool? value) {
                          debugPrint("checkbox onchg");
                          if (_memberAnswers[index]) {
                            //already added, so remove the answer id
                            setState(() {
                              _memberAnswers[index] = false;
                              _memberHasInteracted = true;
                            });
                          } else {
                            //add the answer id to the selected items
                            setState(() {
                              _memberAnswers[index] = true;
                              _memberHasInteracted = true;
                            });
                          }
                        },
                      )))
                  .values
                  .toList() ??
              [])
    ]);
  }

  Widget _getSingleChoiceAnswers() {
    return Column(
      children: widget.question.answers?.map((QuizAnswer answer) {
            return RadioListTile<int>(
              title: Text(answer.answerText ?? ""),
              controlAffinity: ListTileControlAffinity.trailing,
              value: answer.quizAnswerID ?? -1,
              groupValue: _radioSelectedValue,
              onChanged: (value) {
                debugPrint("radio onchg");
                setState(() {
                  _radioSelectedValue = value ?? 0;
                  _radioSelectedValueCorrect = answer.isCorrect == true;
                  _radioSelectedResponse = answer.response ?? "";
                  _memberHasInteracted = true;
                });
              },
            );
          }).toList() ??
          [],
    );
  }

  Widget _getQuestionResponse() {
    bool isCorrect = false;

    if (widget.question.isMultiChoice == true) {
      isCorrect = ListEquality().equals(_actualAnswers, _memberAnswers);
    } else {
      isCorrect = _radioSelectedValueCorrect;
    }

    return Column(
      children: [
        Text(isCorrect
            ? S.current.quizCorrectResponse
            : S.current.quizWrongResponse),
        Text(
          widget.question.response ?? "",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getAnswerResponse() {
    return Text(
      _radioSelectedResponse,
      textAlign: TextAlign.center,
    );
  }

  void _checkAnswer() {
    if (_memberHasInteracted) {
      setState(() {
        _isAnswered = true;
      });
    } else {
      //question hasn't been answered, ask member to respond
      showFlushBar(context, S.current.quizQuestionWarningTitle,
          S.current.quizQuestionWarningText,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColor);
    }
  }

  void _moveToNextQuestion() {
    widget.next(widget.isFinalQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : SizedBox(
            height: widget.screenSize.height - 143,
            width: widget.screenSize.width,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          widget.isFinalCard
                              ? Text(widget.question.response ?? "",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : Container(),
                          HtmlWidget(
                            widget.question.questionText ?? "",
                          ),
                        ],
                      ),
                    ),
                    widget.isFinalCard
                        ? Container()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: widget.question.isMultiChoice == true
                                    ? _getMultiChoiceAnswers()
                                    : _getSingleChoiceAnswers(),
                              ),
                              AnimatedOpacity(
                                // If the widget is visible, animate to 0.0 (invisible).
                                // If the widget is hidden, animate to 1.0 (fully visible).
                                opacity: _isAnswered ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 500),
                                // The green box must be a child of the AnimatedOpacity widget.
                                child: ColorButton(
                                  isUpdating: false,
                                  label: S.current.checkAnswer,
                                  onTap: _checkAnswer,
                                  width: 250,
                                ),
                              ),
                              AnimatedOpacity(
                                // If the widget is visible, animate to 0.0 (invisible).
                                // If the widget is hidden, animate to 1.0 (fully visible).
                                opacity: _isAnswered ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 1000),
                                // The green box must be a child of the AnimatedOpacity widget.
                                child: Column(
                                  children: [
                                    (widget.question.response?.length ?? 0) > 0
                                        ? _getQuestionResponse()
                                        : _getAnswerResponse(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ColorButton(
                                        isUpdating: false,
                                        label: S.current.quizNext,
                                        onTap: _moveToNextQuestion,
                                        width: 250,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                )),
          );
  }
}
