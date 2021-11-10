import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/navigation/settings_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/settings/settings_layout.dart';

class Settings extends StatelessWidget {
  static const String id = "settings_screen";

  @override
  Widget build(BuildContext context) {
    final SettingsArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: SettingsLayout(
            updateYourWhy: args.updateYourWhy,
            updateLessonRecipes: args.updateLessonRecipes,
            onlyShowDailyReminder: args.onlyShowDailyReminder,
          ),
        ),
      ),
    );
  }
}
