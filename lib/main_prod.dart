import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.PROD,
    color: Colors.blue,
    values: FlavorValues(
      baseUrl: "",
      oneSignalAppID: "51d3d0ab-c318-4ae8-8ca2-5e213e6b6975",
      questionnaireUrl: "https://www.thepcosnutritionist.com/",
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
        App(),
      );
    },
    (error, stackTrace) {
      debugPrint('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
