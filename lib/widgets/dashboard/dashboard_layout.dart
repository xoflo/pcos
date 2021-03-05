import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/constants/lesson_type.dart';
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
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  TimeOfDay _customNotificationTime;
  bool _showTodaysTask = true;
  bool _dataUsageWarningDisplayed = false;

  @override
  void initState() {
    super.initState();
    _checkShowTutorial();
    _getDataUsageWarningDisplayed();
  }

  Future<void> _checkShowTutorial() async {
    if (!await PreferencesController()
        .getBool(SharedPreferencesKeys.VIEWED_TUTORIAL)) {
      analytics.logEvent(name: Analytics.ANALYTICS_EVENT_TUTORIAL_BEGIN);
      PreferencesController().saveBool(SharedPreferencesKeys.VIEWED_TUTORIAL);
      await Future.delayed(Duration(seconds: 2), () {
        openBottomSheet(
          context,
          Tutorial(
            closeTutorial: () {
              Navigator.pop(context);
            },
          ),
          Analytics.ANALYTICS_SCREEN_TUTORIAL,
          null,
        );
      });
    }
  }

  void _getDataUsageWarningDisplayed() async {
    final bool dataUsageWarningDisplayed = await PreferencesController()
        .getBool(SharedPreferencesKeys.DATA_USAGE_WARNING_DISPLAYED);
    setState(() {
      _dataUsageWarningDisplayed = dataUsageWarningDisplayed;
    });
  }

  void _openLesson() async {
    final Lesson lesson = Lesson.fromValues(
        1, LessonType.Video, "A Test lesson", "This is just a test lesson.");
    bool showDataUsageWarning = false;

    if (!_dataUsageWarningDisplayed && lesson.lessonType == LessonType.Video) {
      showDataUsageWarning = true;
      //save has seen warning so not to display again
      PreferencesController()
          .saveBool(SharedPreferencesKeys.DATA_USAGE_WARNING_DISPLAYED);
      setState(() {
        _dataUsageWarningDisplayed = true;
      });
    }

    openBottomSheet(
      context,
      CourseLesson(
        showDataUsageWarning: showDataUsageWarning,
        lesson: lesson,
        closeLesson: _closeLesson,
        addToFavourites: _addLessonToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      lesson.lessonId.toString(),
    );
  }

  void _closeLesson() async {
    Navigator.pop(context);

    final bool requestedDailyReminder = await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);

    if (!requestedDailyReminder) {
      //ask the member if they would like a daily reminder first time after closing a lesson
      _askUserForDailyReminder();
    } else if (await NotificationPermissions
            .getNotificationPermissionStatus() !=
        PermissionStatus.granted) {
      if (!await PreferencesController()
          .getBool(SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION)) {
        //ask the member if they would like notifications after closing a lesson after a period of time has passed
        final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        final int firstAppUseTimestamp = await PreferencesController()
            .getInt(SharedPreferencesKeys.APP_FIRST_USE_TIMESTAMP);
        try {
          if ((currentTimestamp - firstAppUseTimestamp) / 1000 > 259200) {
            //longer than three days (259200 seconds) since app first used
            _askUserForNotificationPermission();
          }
        } catch (ex) {
          //seems to be an error with checking timestamps, show request anyway
          _askUserForNotificationPermission();
        }
      }
    }
  }

  void _askUserForDailyReminder() {
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

    PreferencesController()
        .saveBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);

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

  void _askUserForNotificationPermission() {
    void requestNotificationPermission(BuildContext context) async {
      Navigator.of(context).pop();
      await NotificationPermissions.requestNotificationPermissions(
          iosSettings: const NotificationSettingsIos(
              sound: true, badge: true, alert: true));
    }

    PreferencesController()
        .saveBool(SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION);

    showAlertDialog(
      context,
      S.of(context).requestNotificationPermissionTitle,
      S.of(context).requestNotificationPermissionText,
      S.of(context).noText,
      S.of(context).yesText,
      requestNotificationPermission,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }

  void _addLessonToFavourites(dynamic lesson, bool add) {
    debugPrint("*********ADD LESSON TO FAVE");
  }

  void _closeTodaysTask() {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_BUTTON:
            Analytics.ANALYTICS_BUTTON_SAVE_TASK
      },
    );

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
