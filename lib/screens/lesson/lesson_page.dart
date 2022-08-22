import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/notifications/notification_settings.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_task_component.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_wiki_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay2.dart';

class LessonPage extends StatelessWidget {
  LessonPage({Key? key}) : super(key: key);

  static const id = "lesson_page";
  final isPageInitialized = ValueNotifier(false);

  void _closeLesson(BuildContext context) async {
    final bool requestedDailyReminder = await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);

    final bool requestedNotifPermissions = await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION);

    // If user has disabled daily reminders and if this is the first time that
    // they have set it up,  the app will ask the user if they would like a
    // daily reminder after closing a lesson. This will pop up only once to
    // remind the user.
    if (!requestedDailyReminder && !requestedNotifPermissions) {
      _askUserForDailyReminder(context);
    } else {
      final bool isNotificationPermissionGranted =
          await NotificationPermissions.getNotificationPermissionStatus() ==
              PermissionStatus.granted;

      if (!isNotificationPermissionGranted) {
        // Just in case the device doesn't allow checking of notifications,
        // we include a pop-up here
        try {
          _askUserForNotificationPermission(context);
        } catch (ex) {
          _askUserForNotificationPermission(context);
        }
      } else {
        // Close the lesson page normally when the daily reminder is
        // turned on
        Navigator.pop(context);
      }
    }
  }

  void _askUserForDailyReminder(BuildContext context) {
    PreferencesController().saveBool(
        SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION, true);

    void openSettings(BuildContext context) {
      Navigator.pop(context, true);
      Navigator.pushNamed(context, NotificationSettings.id);
    }

    void displaySetupLaterMessage(BuildContext context) async {
      showAlertDialog(
        context,
        S.current.requestDailyReminderTitle,
        S.current.requestDailyReminderNoText,
        S.current.okayText,
        "",
        null,
        (BuildContext context) => Navigator.pop(context, true),
      );
    }

    showAlertDialog(
      context,
      S.current.requestDailyReminderTitle,
      S.current.requestDailyReminderText,
      S.current.noText,
      S.current.yesText,
      openSettings,
      displaySetupLaterMessage,
    );
  }

  void _askUserForNotificationPermission(BuildContext context) {
    void requestNotificationPermission(BuildContext context) async {
      Navigator.of(context).pop();
      await NotificationPermissions.requestNotificationPermissions(
          iosSettings: const NotificationSettingsIos(
              sound: true, badge: true, alert: true));
    }

    showAlertDialog(
      context,
      S.current.requestNotificationPermissionTitle,
      S.current.requestNotificationPermissionText,
      S.current.noText,
      S.current.yesText,
      requestNotificationPermission,
      (context) => Navigator.of(context).pop(),
    );
  }

  Widget getSuccessWidget(ModulesProvider modulesProvider,
      LessonArguments? args, BuildContext context) {
    final wikis = modulesProvider.getLessonWikis(args?.lesson.lessonID ?? 0);
    final contents =
        modulesProvider.getLessonContent(args?.lesson.lessonID ?? 0);
    final tasks = modulesProvider.lessonTasks;

    // A lesson can be completed if the lesson doesn't have
    // any lesson tasks, or if the lesson has a task, and
    // each one of the tasks is already completed.
    // Otherwise, the user cannot proceed to the next lesson.
    final isTaskComplete = tasks.isEmpty ||
        (tasks.isNotEmpty &&
            tasks.every((element) => element.isComplete == true));
    bool hasContents = false;

    for (final content in contents) {
      if (content.body?.isNotEmpty == true) {
        hasContents = true;
        break;
      }
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageComponent(imageUrl: args?.lesson.imageUrl ?? ""),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: HtmlWidget(
                args?.lesson.title ?? "",
                textStyle: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: HtmlWidget(
                args?.lesson.introduction ?? "",
                textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                isSelectable: true,
              ),
            ),
            if (hasContents) ...[
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FilledButton(
                  text: "LESSON PAGES",
                  icon: Image(
                    image: AssetImage("assets/lesson_read_more.png"),
                    height: 20,
                    width: 20,
                  ),
                  margin: EdgeInsets.zero,
                  width: 200,
                  isRoundedButton: false,
                  foregroundColor: Colors.white,
                  backgroundColor: backgroundColor,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    LessonContentPage.id,
                    arguments: args?.lesson,
                  ),
                ),
              ),
            ],
            if (wikis.isNotEmpty == true)
              LessonWikiComponent(lessonWikis: wikis),
            if (tasks.isNotEmpty == true && args?.showTasks == true)
              LessonTaskComponent(lessonTasks: tasks),
            if (args?.showTasks == true) ...[
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  thickness: 1,
                  height: 1,
                  color: textColor.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FilledButton(
                  text: "Complete Lesson",
                  icon: Icon(Icons.check_circle_outline),
                  margin: EdgeInsets.zero,
                  foregroundColor: Colors.white,
                  backgroundColor: backgroundColor,
                  onPressed: isTaskComplete
                      ? () async {
                          final bool setModuleComplete = modulesProvider
                                  .currentModuleLessons.last.lessonID ==
                              args?.lesson.lessonID;

                          await modulesProvider
                              .setLessonAsComplete(
                                args?.lesson.lessonID ?? -1,
                                args?.lesson.moduleID ?? -1,
                                setModuleComplete,
                              )
                              .then((value) => _closeLesson(context));
                        }
                      : null,
                ),
              ),
            ],
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LessonArguments? args =
        ModalRoute.of(context)?.settings.arguments as LessonArguments?;

    return Consumer<ModulesProvider>(
      builder: (context, modulesProvider, child) {
        if (args?.showTasks == true && !isPageInitialized.value) {
          isPageInitialized.value = true;
          modulesProvider.fetchLessonTasks(args?.lesson.lessonID ?? -1);
        }

        return LoaderOverlay(
          loadingStatusNotifier: modulesProvider,
          indicatorPosition: Alignment.center,
          height: MediaQuery.of(context).size.height,
          mainWidget: Scaffold(
              backgroundColor: primaryColor,
              body: WillPopScope(
                onWillPop: () async =>
                    modulesProvider.fetchLessonTasksStatus != LoadingStatus.loading,
                child: Stack(
                  children: [
                    SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Header(
                                title: "Lesson",
                                closeItem: () => Navigator.pop(context),
                              ),
                            ),
                            // if (false)
                            //   NoResults(message: S.current.noItemsFound)
                            // else
                            getSuccessWidget(modulesProvider, args, context)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
