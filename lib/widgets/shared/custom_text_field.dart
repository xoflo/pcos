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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: controller,
            enabled: isEnabled,
            obscureText: isObscure,
            obscuringCharacter: '*',
            style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(isEnabled ? 1 : 0.5)),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(15),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.8)),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.8)),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.8)),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.8)),
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
