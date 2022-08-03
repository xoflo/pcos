import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/change_password/change_password_layout.dart';

class ChangePassword extends StatelessWidget {
  static const String id = "change_password_screen";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 12.0,
            ),
            child: ChangePasswordLayout(),
          ),
        ),
      );
}
