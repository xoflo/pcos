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
    flavor: Flavor.DEV,
    color: Colors.green,
    values: FlavorValues(
      // Currently both the dev API url and the questionnaire url points to prod.
      // This is okay for now, this prod link is not yet the actual live
      // link, as the app is yet to be released. And the Ovie team primarily
      // uses the prod CMS. But later on, when the proper environments are set
      // up, we will be updating the dev and prod links to properly manage and
      // assign the flavors.

      // baseUrl: "https://z-pcos-protocol-as-ae-pp.azurewebsites.net/api/",
      baseUrl: "https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/",
      // subscriptionUrl:
      //     "https://z-pcos-protocol-web-as-ae-pp.azurewebsites.net/subscription",
      subscriptionUrl: "https://questionnaire.ovie.io/subscription",
      oneSignalAppID: "b082abf3-ad45-42de-b294-f910387368f4",
      // questionnaireUrl:
      //     "https://my.thepcosnutritionist.com/about/you/8?mobile=1",
      questionnaireUrl: "https://questionnaire.ovie.io/about/you/8?mobile=1",
      imageStorageFolder: "/v1617670686/images/",
      thumbnailStorageFolder: "/v1617676121/thumbnails/",
      intercomIds: [
        "mjvhncxm",
        "android_sdk-f983d39f10faf073f30cd86aeef4cbdeeb43f62a",
        "ios_sdk-d261cf50066263428896158291f1ea7a86d2a550",
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
