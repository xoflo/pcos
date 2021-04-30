import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  FlavorConfig(
    flavor: Flavor.PROD,
    color: Colors.blue,
    values: FlavorValues(
      baseUrl: "https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/",
      oneSignalAppID: "51d3d0ab-c318-4ae8-8ca2-5e213e6b6975",
      questionnaireUrl: "https://questionaire.thepcosnutritionist.com/",
      imageStorageUrl:
          "https://res.cloudinary.com/dbee2ldxn/image/upload/v1619051729/images/",
      thumbnailStorageUrl:
          "https://res.cloudinary.com/dbee2ldxn/image/upload/v1619051792/thumbnails/",
      videoStorageUrl:
          "https://res.cloudinary.com/dbee2ldxn/video/upload/v1613597581/videos/",
      pdfStorageUrl:
          "https://pcosprotocolstorage.blob.core.windows.net/media/pdf",
      intercomIds: [
        "xsb9gkoh",
        "android_sdk-280570f2464f064f6f0d609249a36972d2af3be4",
        "ios_sdk-d3f8b263524828ea01c350105105ae48d550e129",
      ],
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);

  runZonedGuarded(
    () {
      runApp(
        App(),
      );
    },
    (error, stackTrace) {
      debugPrint('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
