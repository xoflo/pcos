import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PROD,
      color: Colors.blue,
      values: FlavorValues(baseUrl: ""));

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
