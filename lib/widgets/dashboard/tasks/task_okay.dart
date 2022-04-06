import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class TaskOkay extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function(int, String) onSubmit;

  TaskOkay({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTask,
    @required this.onSubmit,
  });

  @override
  _TaskOkayState createState() => _TaskOkayState();
}

class _TaskOkayState extends State<TaskOkay> {
  bool answer = false;
  bool isSaving = false;

  void _saveResponse() {
    widget.onSubmit(widget.lessonTask.lessonTaskID, "Okay");
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
          ColorButton(
            isUpdating: isSaving,
            label: S.current.okayText,
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
