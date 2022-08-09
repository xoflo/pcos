import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/change_password/change_password_layout.dart';

class ChangePassword extends StatelessWidget {
  static const String id = "change_password_screen";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: Scaffold(
              backgroundColor: primaryColor,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: ChangePasswordLayout(),
                ),
              ),
            ),
          );
  }
}
