import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class TaskBool extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function(int, String) onSubmit;

  TaskBool({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTask,
    @required this.onSubmit,
  });

  @override
  _TaskBoolState createState() => _TaskBoolState();
}

class _TaskBoolState extends State<TaskBool> {
  bool answer = false;
  bool isAnswerSet = false;
  bool isSaving = false;
  bool _showValidationMessage = false;

  void _saveResponse() {
    if (!isAnswerSet) {
      setState(() {
        _showValidationMessage = true;
      });
      return;
    }
    widget.onSubmit(widget.lessonTask.lessonTaskID, answer.toString());
  }

  void _setValue(final bool value) {
    setState(() {
      answer = value;
      isAnswerSet = true;
      _showValidationMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color trueColor = !isAnswerSet
        ? Colors.grey
        : answer
            ? Colors.lightGreen
            : Colors.grey;
    final Color falseColor = !isAnswerSet
        ? Colors.grey
        : !answer
            ? Colors.redAccent
            : Colors.grey;

    return SizedBox(
      width: widget.screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.lessonTask.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              widget.lessonTask.description,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _setValue(true);
                },
                child: Icon(
                  Icons.check,
                  color: trueColor,
                  size: 50,
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  _setValue(false);
                },
                child: Icon(
                  Icons.clear,
                  color: falseColor,
                  size: 50,
                ),
              ),
            ],
          ),
          _showValidationMessage
              ? Text(
                  S.of(context).boolTaskValidation,
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                )
              : Container(),
          ColorButton(
            isUpdating: isSaving,
            label: S.of(context).saveText,
            onTap: () {
              _saveResponse();
            },
            width: 70,
          ),
        ],
      ),
    );
  }
}
