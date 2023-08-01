import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails? notificationAppLaunchDetails;

Future<void> main() async {
  FlavorConfig(
    flavor: Flavor.PROD,
    color: Colors.blue,
    values: FlavorValues(
      baseUrl: "https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/",
      subscriptionUrl: "https://questionnaire.ovie.io/subscription",
      oneSignalAppID: "51d3d0ab-c318-4ae8-8ca2-5e213e6b6975",
      questionnaireUrl: "https://questionnaire.ovie.io/about/you/8?mobile=1",
      imageStorageFolder: "/v1620260652/images/",
      thumbnailStorageFolder: "/v1620688098/thumbnails/",
      intercomIds: [
        "mjvhncxm",
        "android_sdk-f983d39f10faf073f30cd86aeef4cbdeeb43f62a",
        "ios_sdk-d261cf50066263428896158291f1ea7a86d2a550",
      ],
      getStreamIoApiKey: 'dd69mrjqdahm',
      getStreamIoAppId: '1259133'
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  final app = await Firebase.initializeApp();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);

  runZonedGuarded(
    () {
      runApp(
        App(app: app),
      );
    },
    (error, stackTrace) {
      //debugPrint('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
