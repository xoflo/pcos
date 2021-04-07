import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class TaskText extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function(int, String) onSubmit;

  TaskText({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTask,
    @required this.onSubmit,
  });

  @override
  _TaskTextState createState() => _TaskTextState();
}

class _TaskTextState extends State<TaskText> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  void _submitText() {
    if (_formKey.currentState.validate()) {
      widget.onSubmit(
          widget.lessonTask.lessonTaskID, textController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
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
            SizedBox(
              width: widget.screenSize.width - 80,
              child: TextFormField(
                maxLines: 2,
                minLines: 2,
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).textTaskValidation;
                  }
                  return null;
                },
              ),
            ),
            ColorButton(
              isUpdating: false,
              label: S.of(context).saveText,
              onTap: () {
                _submitText();
              },
              width: 70,
            ),
          ],
        ),
      ),
    );
  }
}
