import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.DEV,
    color: Colors.green,
    values: FlavorValues(
      baseUrl: "https://z-pcos-protocol-as-ae-pp.azurewebsites.net/api/",
      oneSignalAppID: "ff8ee4d5-9d67-4a8b-aac8-13dc8e150135",
      questionnaireUrl:
          "https://z-pcos-protocol-web-as-ae-pp.azurewebsites.net/register",
      imageStorageUrl:
          "https://res.cloudinary.com/dpjz8zhvy/image/upload/c_scale,q_auto:good,w_500/",
      videoStorageUrl:
          "https://pcosprotocolstorage.blob.core.windows.net/media/",
      intercomIds: [
        "xsb9gkoh",
        "android_sdk-280570f2464f064f6f0d609249a36972d2af3be4",
        "ios_sdk-d3f8b263524828ea01c350105105ae48d550e129",
      ],
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(
    () {
      runApp(
        MyApp(),
      );
    },
    (error, stackTrace) {
      debugPrint('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
