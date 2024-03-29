import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/models/navigation/settings_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/settings/settings_layout.dart';

class Settings extends StatelessWidget {
  static const String id = "settings_screen";

  @override
  Widget build(BuildContext context) {
    final SettingsArguments args =
        ModalRoute.of(context)?.settings.arguments as SettingsArguments;

    return WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: Scaffold(
              backgroundColor: primaryColor,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: SettingsLayout(
                    updateYourWhy: args.updateYourWhy,
                    updateLessonRecipes: args.updateLessonRecipes,
                    updateUseUsername: args.updateUseUsername,
                  ),
                ),
              ),
            ),
          );
  }
}
