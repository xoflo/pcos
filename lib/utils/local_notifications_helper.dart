import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/subjects.dart';
import 'package:thepcosprotocol_app/models/local_notification.dart';

//NB: commented out sections can be put back in if need to perform action when notification opened

final BehaviorSubject<LocalNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<LocalNotification>();
/*
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
*/

Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(LocalNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    /*onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  }*/
  );
}

void requestIOSPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> scheduleDailyReminderNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    final tz.TZDateTime nextScheduledTime,
    final String notificationTitle,
    final String notificationBody) async {
  final String androidPlatformId = "dly_notif_rmdr";
  final String androidPlatformName = "daily_notification_reminder";
  final String androidPlatformDesc = "the daily reminder notification";
  final int dailyReminderNotificationId = 1;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    androidPlatformId,
    androidPlatformName,
    androidPlatformDesc,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
      dailyReminderNotificationId,
      notificationTitle,
      notificationBody,
      nextScheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);

  /*final List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();*/
}

Future<void> turnOffDailyReminderNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  final int dailyReminderNotificationId = 1;
  await flutterLocalNotificationsPlugin.cancel(dailyReminderNotificationId);
}
