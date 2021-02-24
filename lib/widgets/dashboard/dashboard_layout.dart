import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial.dart';
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';

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
    if (!await PreferencesController().getViewedTutorial()) {
      PreferencesController().saveViewedTutorial();
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
  }

  void addToFavourites(dynamic lesson, bool add) {}

  void _scheduleNotification(final bool isPeriodic) {
    if (!isPeriodic) {
      if (customNotificationTime != null) {
        var now = new DateTime.now();
        var notificationTime = new DateTime(now.year, now.month, now.day,
            customNotificationTime.hour, customNotificationTime.minute);
        scheduleNotification(flutterLocalNotificationsPlugin, '4',
            "This is a one off reminder.", notificationTime);
        debugPrint("scheduled a one-off notification.");
      }
    } else {
      scheduleNotificationPeriodically(
          flutterLocalNotificationsPlugin,
          '0',
          "Daily reminder, don't forget to check your progress.",
          RepeatInterval.daily);
      debugPrint("scheduled a periodic notification.");
    }
  }

  Future<void> _showTimeDialog() async {
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    setState(() {
      customNotificationTime = selectedTime;
    });
  }

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
                RaisedButton(
                  onPressed: () {
                    _showTimeDialog();
                  },
                  child: new Text(
                    'chooseTime',
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _scheduleNotification(false);
                  },
                  child: new Text(
                    'scheduleNotification',
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
