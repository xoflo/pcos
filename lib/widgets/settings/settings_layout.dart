import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/constants/local_notification_ids.dart'
    as LocalNotificationIds;
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SettingsLayout extends StatefulWidget {
  @override
  _SettingsLayoutState createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  bool isLoading = true;
  bool isDailyReminderOn = false;
  TimeOfDay dailyReminderTimeOfDay =
      DateTimeUtils.stringToTimeOfDay("12:00 PM");

  @override
  void initState() {
    super.initState();
    getDailyReminderSetting();
  }

  Future<void> getDailyReminderSetting() async {
    final String dailyReminderString = await PreferencesController()
        .getString(SharedPreferencesKeys.DAILY_REMINDER_TIME);
    if (dailyReminderString.length > 0) {
      setState(() {
        dailyReminderTimeOfDay =
            DateTimeUtils.stringToTimeOfDay(dailyReminderString);
        isDailyReminderOn = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveDailyReminder(final bool isOn) async {
    if (isOn) {
      _scheduleNotification();
      await PreferencesController().saveString(
          SharedPreferencesKeys.DAILY_REMINDER_TIME,
          dailyReminderTimeOfDay.format(context));
    } else {
      _turnoffNotification();
      await PreferencesController()
          .saveString(SharedPreferencesKeys.DAILY_REMINDER_TIME, "");
    }
  }

  Future<void> _showTimeDialog() async {
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    setState(() {
      dailyReminderTimeOfDay = selectedTime;
    });

    _saveDailyReminder(true);
  }

  void _scheduleNotification() {
    scheduleNotificationPeriodically(
      flutterLocalNotificationsPlugin,
      LocalNotificationIds.DAILY_REMINDER_TIME,
      "Daily Reminder",
      "Daily reminder, don't forget to check your progress.",
      RepeatInterval.daily,
    );
    debugPrint("scheduled a periodic notification.");
  }

  void _turnoffNotification() {
    turnOffNotificationById(flutterLocalNotificationsPlugin,
        LocalNotificationIds.DAILY_REMINDER_TIME);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: S.of(context).settingsTitle,
            closeItem: () {
              Navigator.pop(context);
            },
          ),
          Container(
            height: DeviceUtils.getRemainingHeight(
                MediaQuery.of(context).size.height,
                false,
                isHorizontal,
                false,
                false),
            child: SingleChildScrollView(
              child: isLoading
                  ? PcosLoadingSpinner()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).settingsDailyReminderText,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Switch(
                                      value: isDailyReminderOn,
                                      onChanged: (value) {
                                        setState(() {
                                          isDailyReminderOn = value;
                                          debugPrint(
                                              "Switch =$isDailyReminderOn");
                                          _saveDailyReminder(value);
                                        });
                                      },
                                      activeTrackColor: secondaryColorLight,
                                      activeColor: secondaryColor,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: isDailyReminderOn
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              dailyReminderTimeOfDay != null
                                                  ? dailyReminderTimeOfDay
                                                      .format(context)
                                                  : "12:00 PM",
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showTimeDialog();
                                              },
                                              child: Icon(
                                                Icons.timer,
                                                size: 30.0,
                                                color: secondaryColorLight,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
