import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/change_password/change_password_layout.dart';

class ChangePassword extends StatelessWidget {
  final Function closeMenuItem;

  ChangePassword({this.closeMenuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
            bottom: 6.0,
            left: 6.0,
            right: 6.0,
          ),
          child: ChangePasswordLayout(
            closeMenuItem: closeMenuItem,
          ),
        ),
      ),
    );
  }
}
