import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/widgets/settings/your_why.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';
import 'package:thepcosprotocol_app/widgets/settings/daily_reminder.dart';
import 'package:thepcosprotocol_app/widgets/settings/notifications_permissions.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SettingsLayout extends StatefulWidget {
  final Function(bool) updateYourWhy;
  final bool onlyShowDailyReminder;

  SettingsLayout(
      {@required this.updateYourWhy, @required this.onlyShowDailyReminder});

  @override
  _SettingsLayoutState createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  bool _isLoading = true;
  bool _isDailyReminderOn = false;
  bool _isYourWhyOn = false;
  bool _hasYourWhyBeenAnswered = false;
  TimeOfDay _dailyReminderTimeOfDay =
      DateTimeUtils.stringToTimeOfDay("12:00 PM");
  PermissionStatus _notificationPermissions = PermissionStatus.unknown;

  @override
  void initState() {
    super.initState();
    _initialiseSettings();
  }

  Future<void> _initialiseSettings() async {
    await _configureLocalTimeZone();
    final String dailyReminderString = await PreferencesController()
        .getString(SharedPreferencesKeys.DAILY_REMINDER_TIME);
    _notificationPermissions =
        await NotificationPermissions.getNotificationPermissionStatus();
    final bool isYourWhyOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    final String whatsYourWhy = await PreferencesController()
        .getString(SharedPreferencesKeys.WHATS_YOUR_WHY);

    if (dailyReminderString.length > 0) {
      setState(() {
        _dailyReminderTimeOfDay =
            DateTimeUtils.stringToTimeOfDay(dailyReminderString);
        _isDailyReminderOn = true;
        _isYourWhyOn = isYourWhyOn;
        _hasYourWhyBeenAnswered = whatsYourWhy.length > 0;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isYourWhyOn = isYourWhyOn;
        _hasYourWhyBeenAnswered = whatsYourWhy.length > 0;
        _isLoading = false;
      });
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    String timeZone;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      timeZone = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      timeZone = "";
    }

    if (timeZone.length > 0) {
      tz.setLocalLocation(tz.getLocation(timeZone));
    }
  }

  tz.TZDateTime _nextInstanceOfSelectedTime(final int hour, final int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _saveDailyReminder(final bool isOn) async {
    setState(() {
      _isDailyReminderOn = isOn;
    });

    if (isOn) {
      _scheduleNotification();
      await PreferencesController().saveString(
          SharedPreferencesKeys.DAILY_REMINDER_TIME,
          _dailyReminderTimeOfDay.format(context));
      PreferencesController()
          .saveBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER, true);
    } else {
      turnOffDailyReminderNotification(flutterLocalNotificationsPlugin);
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
      _dailyReminderTimeOfDay = selectedTime;
    });

    _saveDailyReminder(true);
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
      S.of(context).dailyReminderTitle,
      S.of(context).dailyReminderText,
    );
  }

  void _requestNotificationPermission() async {
    final newPermission =
        await NotificationPermissions.requestNotificationPermissions(
      iosSettings:
          const NotificationSettingsIos(sound: true, badge: true, alert: true),
    );
    setState(() {
      _notificationPermissions = newPermission;
    });
  }

  Future<void> _saveYourWhy(final bool isOn) async {
    setState(() {
      _isYourWhyOn = isOn;
    });

    PreferencesController()
        .saveBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED, isOn);
    //bubble up so the course screen gets updated
    widget.updateYourWhy(isOn);
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight,
                  child: SingleChildScrollView(
                    child: _isLoading
                        ? PcosLoadingSpinner()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                NotificationsPermissions(
                                  notificationPermissions:
                                      _notificationPermissions,
                                  requestNotificationPermission:
                                      _requestNotificationPermission,
                                ),
                                DailyReminder(
                                  isDailyReminderOn: _isDailyReminderOn,
                                  dailyReminderTimeOfDay:
                                      _dailyReminderTimeOfDay,
                                  notificationPermissions:
                                      _notificationPermissions,
                                  saveDailyReminder: _saveDailyReminder,
                                  showTimeDialog: _showTimeDialog,
                                ),
                                widget.onlyShowDailyReminder
                                    ? Container()
                                    : YourWhySetting(
                                        isYourWhyOn: _isYourWhyOn,
                                        hasYourWhyBeenEntered:
                                            _hasYourWhyBeenAnswered,
                                        saveYourWhy: _saveYourWhy),
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
