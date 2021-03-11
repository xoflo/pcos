import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class DailyReminder extends StatelessWidget {
  final bool isDailyReminderOn;
  final TimeOfDay dailyReminderTimeOfDay;
  final PermissionStatus notificationPermissions;
  final Function(bool) saveDailyReminder;
  final Function showTimeDialog;

  DailyReminder({
    @required this.isDailyReminderOn,
    @required this.dailyReminderTimeOfDay,
    @required this.notificationPermissions,
    @required this.saveDailyReminder,
    @required this.showTimeDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).settingsDailyReminderText,
                style: Theme.of(context).textTheme.headline5,
              ),
              Switch(
                value: isDailyReminderOn,
                onChanged: (value) {
                  if (notificationPermissions == PermissionStatus.granted) {
                    saveDailyReminder(value);
                    return;
                  }
                  showFlushBar(
                      context,
                      S.of(context).notificationPermissionsNeedToAllowTitle,
                      S.of(context).notificationPermissionsNeedToAllowText,
                      backgroundColor: Colors.white,
                      borderColor: primaryColorLight,
                      primaryColor: primaryColor);
                },
                activeTrackColor: secondaryColor,
                activeColor: secondaryColor,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: isDailyReminderOn
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        dailyReminderTimeOfDay != null
                            ? dailyReminderTimeOfDay.format(context)
                            : "12:00 PM",
                      ),
                      GestureDetector(
                        onTap: () {
                          showTimeDialog();
                        },
                        child: Icon(
                          Icons.timer,
                          size: 30.0,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
