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
      blobStorageUrl:
          "https://pcosprotocolstorage.blob.core.windows.net/media/",
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
