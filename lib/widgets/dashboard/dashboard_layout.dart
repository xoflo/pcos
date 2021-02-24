import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial.dart';
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/menu/settings.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  TimeOfDay customNotificationTime;

  @override
  void initState() {
    super.initState();
    checkShowTutorial();
  }

  Future<void> checkShowTutorial() async {
    if (!await PreferencesController()
        .getBool(SharedPreferencesKeys.VIEWED_TUTORIAL)) {
      PreferencesController().saveBool(SharedPreferencesKeys.VIEWED_TUTORIAL);
      await Future.delayed(Duration(seconds: 2), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Tutorial(
            closeTutorial: () {
              Navigator.pop(context);
            },
          ),
        );
      });
    }
  }

  void openLesson() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CourseLesson(
        lesson: Lesson(),
        closeLesson: closeLesson,
        addToFavourites: addToFavourites,
      ),
    );
  }

  void closeLesson() async {
    Navigator.pop(context);

    if (!await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER)) {
      void openSettings(BuildContext context) {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, Settings.id);
      }

      void displaySetupLaterMessage(BuildContext context) {
        Navigator.of(context).pop();
        showAlertDialog(
          context,
          S.of(context).requestDailyReminderTitle,
          S.of(context).requestDailyReminderNoText,
          S.of(context).okayText,
          "",
          null,
          (BuildContext context) {
            Navigator.of(context).pop();
          },
        );
      }

      showAlertDialog(
        context,
        S.of(context).requestDailyReminderTitle,
        S.of(context).requestDailyReminderText,
        S.of(context).noText,
        S.of(context).yesText,
        openSettings,
        displaySetupLaterMessage,
      );
    }
  }

  void addToFavourites(dynamic lesson, bool add) {}

  void _requestPermission() {
    if (Platform.isIOS) {
      requestIOSPermissions(flutterLocalNotificationsPlugin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Watch your latest lesson now."),
                    GestureDetector(
                      onTap: () {
                        openLesson();
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color: secondaryColorLight,
                        size: 48,
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    _requestPermission();
                  },
                  child: new Text(
                    'requestPermission',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
