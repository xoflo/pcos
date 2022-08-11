import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/screens/settings/toggle_switch.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  static const String id = "notifications_setttings_screen";

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isDailyReminderSet = false;
  Future<bool> get isNotificationGranted async =>
      await NotificationPermissions.getNotificationPermissionStatus() ==
      PermissionStatus.granted;

  TimeOfDay _dailyReminderTimeOfDay =
      DateTimeUtils.stringToTimeOfDay("12:00 PM");

  @override
  void initState() {
    super.initState();
    _setDailyReminderValue();
  }

  tz.TZDateTime _nextInstanceOfSelectedTime(final int hour, final int minute) {
    // The now from the DateTime and the now converted to TZDateTime may not
    // always be accurate, so we need to set the TZDateTime now independently.
    // Using TZDateTime.now adjusts the time to the UTC time instead of the
    // actual local time, which is an issue with the library itself.
    final now = DateTime.now();

    final tz.TZDateTime localizedNow = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(localizedNow)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _scheduleNotification() {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_DAILY_REMINDER,
    );

    turnOffDailyReminderNotification(flutterLocalNotificationsPlugin);
    final tz.TZDateTime zonedSelectedTime = _nextInstanceOfSelectedTime(
      _dailyReminderTimeOfDay.hour,
      _dailyReminderTimeOfDay.minute,
    );
    scheduleDailyReminderNotification(
      flutterLocalNotificationsPlugin,
      zonedSelectedTime,
      S.current.dailyReminderTitle,
      S.current.dailyReminderText,
    );
  }

  Future _setDailyReminderValue() async {
    final bool requestedDailyReminder = await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);
    final bool isNotificationPermissionGranted = await isNotificationGranted;

    setState(() => isDailyReminderSet =
        requestedDailyReminder && (isNotificationPermissionGranted));
  }

  void _askUserForNotificationPermission() {
    void requestNotificationPermission(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: SafeArea(
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
                          onToggle: (isOn) async {
                            if (!(await isNotificationGranted)) {
                              _askUserForNotificationPermission();
                            } else {
                              if (isOn) {
                                _scheduleNotification();
                                await PreferencesController().saveString(
                                    SharedPreferencesKeys.DAILY_REMINDER_TIME,
                                    _dailyReminderTimeOfDay.format(context));
                              } else {
                                turnOffDailyReminderNotification(
                                    flutterLocalNotificationsPlugin);
                                await PreferencesController().saveString(
                                    SharedPreferencesKeys.DAILY_REMINDER_TIME,
                                    "");
                              }
                              PreferencesController().saveBool(
                                  SharedPreferencesKeys
                                      .REQUESTED_DAILY_REMINDER,
                                  isOn);
                              setState(() => isDailyReminderSet = isOn);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
