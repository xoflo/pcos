import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/module_export.dart';
import 'package:thepcosprotocol_app/models/navigation/previous_modules_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/settings_arguments.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/other/previous_modules.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/tasks.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/your_why.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/menu/settings.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/your_progress.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/current_module.dart';
import 'package:thepcosprotocol_app/widgets/modules/previous_modules_carousel.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/screens/other/previous_modules.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatefulWidget {
  final bool showYourWhy;

  DashboardLayout({@required this.showYourWhy});

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _dataUsageWarningDisplayed = false;

  @override
  void initState() {
    super.initState();
    _initialise();
    _checkShowTutorial();
  }

  Future<void> _initialise() async {
    final bool dataUsageWarningDisplayed = await PreferencesController()
        .getBool(SharedPreferencesKeys.DATA_USAGE_WARNING_DISPLAYED);

    setState(() {
      _dataUsageWarningDisplayed = dataUsageWarningDisplayed;
    });
  }

  Future<void> _checkShowTutorial() async {
    if (!await PreferencesController()
        .getBool(SharedPreferencesKeys.VIEWED_TUTORIAL)) {
      analytics.logEvent(name: Analytics.ANALYTICS_EVENT_TUTORIAL_BEGIN);
      PreferencesController()
          .saveBool(SharedPreferencesKeys.VIEWED_TUTORIAL, true);
      await Future.delayed(Duration(seconds: 2), () {
        openBottomSheet(
          context,
          Tutorial(
            isStartUp: true,
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

  void _openLesson(
      final Lesson lesson, final ModulesProvider modulesProvider) async {
    //mark lesson a complete if not already
    debugPrint("******open lesson isComplete=${lesson.isComplete}");
    if (!lesson.isComplete) {
      //is this the last lesson of the Module, if so, also setComplete for module
      final bool setModuleComplete =
          modulesProvider.currentModuleLessons.last.lessonID == lesson.lessonID;
      modulesProvider.setLessonAsComplete(
          lesson.lessonID, lesson.moduleID, setModuleComplete);
    }

    bool showDataUsageWarning = false;

    if (!_dataUsageWarningDisplayed) {
      showDataUsageWarning = true;
      //save has seen warning so not to display again
      PreferencesController()
          .saveBool(SharedPreferencesKeys.DATA_USAGE_WARNING_DISPLAYED, true);
      setState(() {
        _dataUsageWarningDisplayed = true;
      });
    }

    openBottomSheet(
      context,
      CourseLesson(
        modulesProvider: modulesProvider,
        showDataUsageWarning: showDataUsageWarning,
        lesson: lesson,
        closeLesson: _closeLesson,
        addToFavourites: _addLessonToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      lesson.lessonID.toString(),
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

  void _openPreviousModules(
      final BuildContext context, final ModulesProvider modulesProvider) {
    Navigator.pushNamed(context, PreviousModules.id,
        arguments: PreviousModulesArguments(modulesProvider));
  }

  void _askUserForDailyReminder() {
    void openSettings(BuildContext context) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, Settings.id,
          arguments: SettingsArguments((bool) {}, true));
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
        .saveBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER, true);

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

    PreferencesController().saveBool(
        SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION, true);

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

  void _saveTask() {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_BUTTON:
            Analytics.ANALYTICS_BUTTON_SAVE_TASK
      },
    );

    /*setState(() {
      _showTodaysTask = false;
    });*/
  }

  Widget getCurrentModule(
    final Size screenSize,
    final bool isHorizontal,
    final ModulesProvider modulesProvider,
  ) {
    switch (modulesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noResultsLessons);
      case LoadingStatus.success:
        debugPrint(
            "currentModule lessons count = ${modulesProvider.currentModuleLessons.length}");
        return CurrentModule(
          screenSize: screenSize,
          isHorizontal: isHorizontal,
          modulesProvider: modulesProvider,
          showPreviousModule:
              modulesProvider.previousModules.length > 0 ? true : false,
          openLesson: _openLesson,
          openPreviousModules: _openPreviousModules,
        );
    }
    return Container();
  }

  Widget getTasks(
    final Size screenSize,
    final bool isHorizontal,
    final ModulesProvider modulesProvider,
    final double topPadding,
  ) {
    switch (modulesProvider.status) {
      case LoadingStatus.success:
        debugPrint(
            "LESSON TASKS ON DASHBAORD = ${modulesProvider.currentLessonTasks.length}");
        debugPrint(
            "CURRENT LESSON COMPLETE=${modulesProvider.currentLesson.isComplete}");
        return modulesProvider.currentLesson.isComplete
            ? Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: Tasks(
                  screenSize: screenSize,
                  isHorizontal: isHorizontal,
                  lessonTasks: modulesProvider.currentLessonTasks,
                  onSubmit: _saveTask,
                ),
              )
            : Container();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    final double topPadding = widget.showYourWhy ? 20 : 30;
    return SingleChildScrollView(
      child: Container(
        height: DeviceUtils.getRemainingHeight(
            screenSize.height, false, isHorizontal, false, false),
        child: Consumer<ModulesProvider>(
          builder: (context, model, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.showYourWhy ? YourWhy() : Container(),
              getTasks(screenSize, isHorizontal, model, topPadding),
              Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: getCurrentModule(screenSize, isHorizontal, model),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
