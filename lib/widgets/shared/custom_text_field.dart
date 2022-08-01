import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.title,
    this.blankMessageError,
    this.isObscure = false,
    this.isEnabled = true,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final String? blankMessageError;
  final bool isObscure;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final textContentColor = textColor.withOpacity(isEnabled ? 1 : 0.5);
    final textBoxColor = textColor.withOpacity(isEnabled ? 0.8 : 0.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          obscureText: isObscure,
          obscuringCharacter: '*',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w500,
                color: textContentColor,
              ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(15),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: textBoxColor),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textBoxColor),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textBoxColor),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textBoxColor),
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          validator: (value) {
            if (value?.isEmpty == true) {
              return blankMessageError;
            }
            return null;
          },
        ),
      ],
    );
  }
}
