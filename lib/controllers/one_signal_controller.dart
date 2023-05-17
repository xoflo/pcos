import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class OneSignalController {
  // Keep this variable here, as it is only used here
  static const _pcosType = "pcos_type";
  static const int _daysShouldPermissionTrigger = 3;

  // Remove external user ID and pcos type so that they don't
  // receive push notifications directly
  void deleteOneSignal() {
    OneSignal.shared.removeExternalUserId();
    OneSignal.shared.deleteTag(_pcosType);
  }

  Future setOneSignal(
      {required String userId, required String pcosType}) async {
    await OneSignal.shared.setExternalUserId(userId);
    await OneSignal.shared.sendTag(_pcosType, pcosType);
  }

  Future<bool> promptNotifiationsPermission() async =>
      OneSignal.shared.promptUserForPushNotificationPermission();

  bool shouldTriggerNotifPermission(SharedPreferences prefs) {
    if (prefs.getInt(
            SharedPreferencesKeys.NOTIFICATION_PROMPT_CHECK_TIMESTAMP) ==
        null) {
      prefs.setInt(SharedPreferencesKeys.NOTIFICATION_PROMPT_CHECK_TIMESTAMP,
          DateTime.now().millisecondsSinceEpoch);

      return false;
    } else {
      int? savedTime = prefs
          .getInt(SharedPreferencesKeys.NOTIFICATION_PROMPT_CHECK_TIMESTAMP);

      var savedDate = DateTime.fromMillisecondsSinceEpoch(savedTime ?? 0);

      DateTime todayTimeStamp = DateTime.now();

      Duration diff = savedDate.difference(todayTimeStamp);

      return diff.inDays.toInt() >= _daysShouldPermissionTrigger;
    }
  }
}
