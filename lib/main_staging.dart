import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.STAGING,
    color: Colors.deepPurpleAccent,
    values: FlavorValues(
      baseUrl: "https://z-pcos-protocol-as-ae-pp.azurewebsites.net/api/",
      oneSignalAppID: "74c753f5-23cf-4819-b732-f4bc41f06c92",
      questionnaireUrl: "https://www.thepcosnutritionist.com/",
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
