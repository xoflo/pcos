import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/settings/toggle_switch.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  static const String id = "notifications_setttings_screen";

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isDailyReminderSet = false;
  @override
  void initState() {
    super.initState();
    _setDailyReminderValue();
  }

  Future _setDailyReminderValue() async {
    final bool requestedDailyReminder = await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);

    setState(() => isDailyReminderSet = requestedDailyReminder);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                children: [
                  Header(
                    title: "Notification Settings",
                    closeItem: () => Navigator.pop(context),
                  ),
                  Card(
                    margin: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: ToggleSwitch(
                          title: "Daily message",
                          value: isDailyReminderSet,
                          onToggle: (isOn) {
                            PreferencesController().saveBool(
                                SharedPreferencesKeys.REQUESTED_DAILY_REMINDER,
                                isOn);
                            setState(() => isDailyReminderSet = isOn);
                          },
                        )
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Flexible(
                        //       child: Text(
                        //         "Daily message",
                        //         style: TextStyle(fontSize: 16, color: textColor),
                        //       ),
                        //     ),
                        //     CupertinoSwitch(
                        //       value: isDailyReminderSet,
                        //       activeColor: backgroundColor,
                        //       trackColor: secondaryColor,
                        //       onChanged: (isOn) {
                        // PreferencesController().saveBool(
                        //     SharedPreferencesKeys
                        //         .REQUESTED_DAILY_REMINDER,
                        //     isOn);
                        // setState(() => isDailyReminderSet = isOn);
                        //       },
                        //     ),
                        //   ],
                        // ),
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
