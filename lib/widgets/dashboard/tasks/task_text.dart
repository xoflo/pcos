import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class TaskText extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function(int?, String) onSubmit;

  TaskText({
    required this.screenSize,
    required this.isHorizontal,
    required this.lessonTask,
    required this.onSubmit,
  });

  @override
  _TaskTextState createState() => _TaskTextState();
}

class _TaskTextState extends State<TaskText> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  void _submitText() {
    if (_formKey.currentState?.validate() == true) {
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
              widget.lessonTask.title ?? "",
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: HtmlWidget(widget.lessonTask.description ?? ""),
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
                  if (value?.isEmpty == true) {
                    return S.current.textTaskValidation;
                  }
                  return null;
                },
              ),
            ),
            ColorButton(
              isUpdating: false,
              label: S.current.saveText,
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
