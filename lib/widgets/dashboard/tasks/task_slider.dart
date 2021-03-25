import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class TaskSlider extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function onSubmit;

  TaskSlider({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTask,
    @required this.onSubmit,
  });

  @override
  _TaskSliderState createState() => _TaskSliderState();
}

class _TaskSliderState extends State<TaskSlider> {
  double _sliderValue = 2.5;
  bool isSaving = false;

  void _saveResponse() {
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
