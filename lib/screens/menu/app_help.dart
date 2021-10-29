import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/app_help/app_help_layout.dart';

class AppHelp extends StatelessWidget {
  static const String id = "app_help_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: AppHelpLayout(),
        ),
      ),
    );
  }
}
