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
      // Below is the DEV OneSignal App ID
      oneSignalAppID: "b082abf3-ad45-42de-b294-f910387368f4",
      // Creating the iOS build via archiving requires `main.dart`. The default
      // OneSignal App ID is the DEV. However, if we want to create an iOS
      // production build, we should uncomment the oneSignalAppID value below
      // because it refers to the PROD OneSignal App ID
      // oneSignalAppID: "51d3d0ab-c318-4ae8-8ca2-5e213e6b6975",
      questionnaireUrl: "https://questionnaire.ovie.io/about/you/8?mobile=1",
      imageStorageFolder: "/v1617670686/images/",
      thumbnailStorageFolder: "/v1617676121/thumbnails/",
      intercomIds: [
        "xsb9gkoh",
        "android_sdk-280570f2464f064f6f0d609249a36972d2af3be4",
        "ios_sdk-d3f8b263524828ea01c350105105ae48d550e129",
      ],
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
