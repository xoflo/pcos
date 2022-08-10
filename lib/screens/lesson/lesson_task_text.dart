import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

class LessonTaskText extends StatefulWidget {
  const LessonTaskText({Key? key, required this.onSave}) : super(key: key);

  final Function(String) onSave;

  @override
  State<LessonTaskText> createState() => _LessonTaskTextState();
}

class _LessonTaskTextState extends State<LessonTaskText> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextFormField(
            controller: _textController,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              counterText: "",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
            maxLines: null,
            minLines: 10,
          ),
          SizedBox(height: 25),
          ValueListenableBuilder<TextEditingValue>(
              valueListenable: _textController,
              builder: (context, value, child) {
                return FilledButton(
                  onPressed: value.text.isNotEmpty
                      ? () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          widget.onSave(value.text);
                        }
                      : null,
                  text: "SAVE",
                  margin: EdgeInsets.zero,
                  foregroundColor: Colors.white,
                  backgroundColor: backgroundColor,
                );
              })
        ],
      );
}
