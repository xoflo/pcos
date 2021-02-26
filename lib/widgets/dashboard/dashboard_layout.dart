import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/menu/settings.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/your_progress.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/current_lesson.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/previous_lessons.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/progress_slider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  TimeOfDay _customNotificationTime;
  bool _showTodaysTask = true;

  @override
  void initState() {
    super.initState();
    _checkShowTutorial();
  }

  Future<void> _checkShowTutorial() async {
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

  void _openLesson() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CourseLesson(
        lesson: Lesson(),
        closeLesson: _closeLesson,
        addToFavourites: _addLessonToFavourites,
      ),
    );
  }

  void _closeLesson() async {
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

  void _addLessonToFavourites(dynamic lesson, bool add) {
    debugPrint("*********ADD LESSON TO FAVE");
  }

  void _closeTodaysTask() {
    setState(() {
      _showTodaysTask = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Container(
      height: DeviceUtils.getRemainingHeight(
          screenSize.height, false, isHorizontal, false, false),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _showTodaysTask
                ? ProgressSlider(
                    screenSize: screenSize,
                    isHorizontal: isHorizontal,
                    onSubmit: _closeTodaysTask,
                  )
                : Container(),
            YourProgress(),
            CurrentLesson(
              isNew: true,
              screenSize: screenSize,
              isHorizontal: isHorizontal,
              openLesson: _openLesson,
              closeLesson: _closeLesson,
            ),
            PreviousLessons(
              screenSize: screenSize,
              isHorizontal: isHorizontal,
              openLesson: _openLesson,
              closeLesson: _closeLesson,
            ),
          ],
        ),
      ),
    );
  }
}
