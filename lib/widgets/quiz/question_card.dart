import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final Size screenSize;
  final Function next;

  QuestionCard({
    @required this.question,
    @required this.screenSize,
    @required this.next,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _isLoading = true;
  List<int> _checkboxSelectedValues = [];
  bool _radioSelectedValueCorrect = false;
  int _radioSelectedValue = 0;
  bool _isAnswered = false;
  List<bool> _actualAnswers = [];
  List<bool> _memberAnswers = [];

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  Future<void> _initialise() async {
    for (QuizAnswer answer in widget.question.answers) {
      _actualAnswers.add(answer.isCorrect);
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
              .asMap()
              .map((index, answer) => MapEntry(
                  index,
                  CheckboxListTile(
                    title: Text(answer.answerText),
                    value: _memberAnswers[index],
                    onChanged: (bool value) {
                      debugPrint("checkbox onchg");
                      if (_memberAnswers[index]) {
                        //already added, so remove the answer id
                        setState(() {
                          _memberAnswers[index] = false;
                        });
                      } else {
                        //add the answer id to the selected items
                        setState(() {
                          _memberAnswers[index] = true;
                        });
                      }
                    },
                  )))
              .values
              .toList())
    ]);
  }

  Widget _getSingleChoiceAnswers() {
    return Column(
      children: widget.question.answers.map((QuizAnswer answer) {
        return RadioListTile<int>(
          title: Text(answer.answerText),
          controlAffinity: ListTileControlAffinity.trailing,
          value: answer.quizAnswerID,
          groupValue: _radioSelectedValue,
          onChanged: (value) {
            debugPrint("radio onchg");
            setState(() {
              _radioSelectedValue = value;
              _radioSelectedValueCorrect = answer.isCorrect;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _getQuestionResponse() {
    bool isCorrect = false;

    for (bool answer in _memberAnswers) {
      debugPrint("Q = ${widget.question.questionText} ANSWER=$answer");
    }

    if (widget.question.isMultiChoice) {
      isCorrect = ListEquality().equals(_actualAnswers, _memberAnswers);
    } else {
      isCorrect = _radioSelectedValueCorrect;
    }
//TODO: add to strings
    return Column(
      children: [
        Text(isCorrect ? "Well done" : "Unlucky"),
        Text(
          widget.question.response,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getAnswerResponse() {
    return Container(child: Text("ANSWER RESP"));
  }

  void _checkAnswer() {
    //TODO: check they have attempted to answer
    setState(() {
      _isAnswered = true;
    });
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
                      child: Text(
                        widget.question.questionText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: widget.question.isMultiChoice
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
                          widget.question.response.length > 0
                              ? _getQuestionResponse()
                              : _getAnswerResponse(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ColorButton(
                              isUpdating: false,
                              label: S.current.quizNext,
                              onTap: widget.next,
                              width: 250,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          );
  }
}
