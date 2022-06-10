import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SettingsLayout extends StatefulWidget {
  final Function(bool) updateYourWhy;
  final Function(bool) updateLessonRecipes;
  final Function(bool) updateUseUsername;

  SettingsLayout({
    required this.updateYourWhy,
    required this.updateLessonRecipes,
    required this.updateUseUsername,
  });

  @override
  _SettingsLayoutState createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  @override
  void initState() {
    super.initState();
    _initialiseSettings();
  }

  Future<void> _initialiseSettings() async {
    final bool isYourWhyOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    final bool isLessonRecipesOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    final bool isUseUsernameOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.USERNAME_USED);

    setState(() {
      _preferenceOptions.addAll({
        "Display “Your Why”": isYourWhyOn,
        "Display lesson recipes": isLessonRecipesOn,
        "Use username": isUseUsernameOn,
      });
    });
  }

  Future<void> _saveLessonRecipes(final bool isOn) async {
    PreferencesController().saveBool(
        SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD, isOn);
    widget.updateLessonRecipes(isOn);
  }

  Future<void> _saveDisplayWhy(final bool isOn) async {
    PreferencesController()
        .saveBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED, isOn);
    widget.updateYourWhy(isOn);
  }

  Future<void> _saveUseUsername(final bool isOn) async {
    PreferencesController().saveBool(SharedPreferencesKeys.USERNAME_USED, isOn);
    widget.updateUseUsername(isOn);
  }

  Map<String, bool> _preferenceOptions = {};

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              title: "Account Preferences",
              closeItem: () => Navigator.pop(context),
              showDivider: true,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _preferenceOptions.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child:
                                Text(_preferenceOptions.keys.elementAt(index)),
                          ),
                          CupertinoSwitch(
                            value: _preferenceOptions.values.elementAt(index),
                            activeColor: backgroundColor,
                            trackColor: secondaryColor,
                            onChanged: (isOn) {
                              final key =
                                  _preferenceOptions.keys.elementAt(index);

                              setState(() {
                                _preferenceOptions.addAll({key: isOn});
                              });

                              switch (index) {
                                case 0:
                                  _saveDisplayWhy(isOn);
                                  break;
                                case 1:
                                  _saveLessonRecipes(isOn);
                                  break;
                                case 2:
                                  _saveUseUsername(isOn);
                                  break;
                                default:
                                  break;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(thickness: 1, height: 1, color: dividerColor),
                  ],
                ),
              ),
            ),

            // Expanded(
            //   child: LayoutBuilder(
            //     builder: (BuildContext context, BoxConstraints constraints) {
            //       return Container(
            //         height: constraints.maxHeight,
            //         child: SingleChildScrollView(
            //           child: _isLoading
            //               ? PcosLoadingSpinner()
            //               : Padding(
            //                   padding: const EdgeInsets.all(16.0),
            //                   child: Column(
            //                     children: [
            //                       NotificationsPermissions(
            //                         notificationPermissions:
            //                             _notificationPermissions,
            //                         requestNotificationPermission:
            //                             _requestNotificationPermission,
            //                       ),
            //                       DailyReminder(
            //                         isDailyReminderOn: _isDailyReminderOn,
            //                         dailyReminderTimeOfDay:
            //                             _dailyReminderTimeOfDay,
            //                         notificationPermissions:
            //                             _notificationPermissions,
            //                         saveDailyReminder: _saveDailyReminder,
            //                         showTimeDialog: _showTimeDialog,
            //                       ),
            //                       widget.onlyShowDailyReminder
            //                           ? Container()
            //                           : Column(
            //                               children: [
            //                                 YourWhySetting(
            //                                     isYourWhyOn: _isYourWhyOn,
            //                                     hasYourWhyBeenEntered:
            //                                         _hasYourWhyBeenAnswered,
            //                                     saveYourWhy: _saveYourWhy),
            //                                 LessonRecipes(
            //                                     isLessonRecipesOn:
            //                                         _isLessonRecipesOn,
            //                                     saveLessonRecipes:
            //                                         _saveLessonRecipes),
            //                               ],
            //                             ),
            //                     ],
            //                   ),
            //                 ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      );
}
