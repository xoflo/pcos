import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class TaskRating extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function(int, String) onSubmit;

  TaskRating({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTask,
    @required this.onSubmit,
  });

  @override
  _TaskRatingState createState() => _TaskRatingState();
}

class _TaskRatingState extends State<TaskRating> {
  double _sliderValue = 2.5;
  bool isSaving = false;

  void _saveResponse() {
    widget.onSubmit(
        widget.lessonTask.lessonTaskID, _sliderValue.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
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
            child: HtmlWidget(widget.lessonTask.description),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied_outlined,
                color: primaryColor,
                size: 30,
              ),
              Slider(
                value: _sliderValue,
                min: 0,
                max: 5,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
              Icon(
                Icons.sentiment_satisfied_outlined,
                color: primaryColor,
                size: 30,
              ),
            ],
          ),
          ColorButton(
            isUpdating: isSaving,
            label: S.current.saveText,
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
