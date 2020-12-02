import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thepcosprotocol_app/pcos_protocol_app.dart';
import 'package:thepcosprotocol_app/widgets/app_loading.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Crashlytics - set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  //initialise Crashlytics for app
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Should we show error message if initialization failed?
    //if (_error) {
    //  return SomethingWentWrong();
    //}

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return AppLoading();
    }

    return PCOSProtocolApp();
  }
}
