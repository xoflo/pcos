import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
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
  Future<bool> get isNotificationGranted async =>
      await NotificationPermissions.getNotificationPermissionStatus() ==
      PermissionStatus.granted;

  @override
  void initState() {
    super.initState();
    _setDailyReminderValue();
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
                        onToggle: (isOn) async {
                          if (!(await isNotificationGranted)) {
                            _askUserForNotificationPermission();
                          } else {
                            PreferencesController().saveBool(
                                SharedPreferencesKeys.REQUESTED_DAILY_REMINDER,
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
      );
}
