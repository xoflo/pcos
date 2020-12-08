import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:thepcosprotocol_app/pcos_protocol_app.dart';
import 'package:thepcosprotocol_app/widgets/app_loading.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

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

  // OneSignal initialisation - Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initializeOneSignal() async {
    if (!mounted) return;

    //TODO: remove this temporary dbugging level
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      debugPrint(
          "*** RECEIVED PN - message=${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint(
          "*** OPENED PN - message=${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      debugPrint(
          "*** CLICKED INAPP - message=${action.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      debugPrint("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      debugPrint("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      debugPrint(
          "EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.init(FlavorConfig.instance.values.oneSignalAppID,
        iOSSettings: settings);
    debugPrint("*** OneSignal initialised");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    //TODO: ask for permission on iOS somewhere else later
    //bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    initializeOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    // Should we show error message if initialization failed or record issue somewhere?
    //if (_error) {
    //  return SomethingWentWrong();
    //}

    return PCOSProtocolApp(initialised: _initialized);
  }
}
