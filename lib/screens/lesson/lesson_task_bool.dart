import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

class LessonTaskBool extends StatefulWidget {
  const LessonTaskBool({Key? key, required this.onSave}) : super(key: key);

  final Function(bool?) onSave;

  @override
  State<LessonTaskBool> createState() => _LessonTaskBoolState();
}

class _LessonTaskBoolState extends State<LessonTaskBool> {
  bool? isTrue;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => isTrue = true),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isTrue == true ? backgroundColor.withOpacity(0.1) : null,
                border: Border.all(
                  width: isTrue == true ? 2 : 1,
                  color: isTrue == true
                      ? backgroundColor
                      : textColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                "Yes",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: isTrue == true
                        ? backgroundColor
                        : textColor.withOpacity(0.8)),
              ),
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () => setState(() => isTrue = false),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color:
                    isTrue == false ? backgroundColor.withOpacity(0.1) : null,
                border: Border.all(
                  width: isTrue == false ? 2 : 1,
                  color: isTrue == false
                      ? backgroundColor
                      : textColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                "No",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: isTrue == false
                        ? backgroundColor
                        : textColor.withOpacity(0.8)),
              ),
            ),
          ),
          SizedBox(height: 25),
          FilledButton(
            onPressed: isTrue != null ? () => widget.onSave(isTrue) : null,
            text: "SAVE",
            margin: EdgeInsets.zero,
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
          )
        ],
      );
}
