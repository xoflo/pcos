import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalController {
  // Keep this variable here, as it is only used here
  static const _pcosType = "pcos_type";

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
}
