import 'package:flutter/material.dart';
import 'dart:io';
import 'package:package_info/package_info.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/widgets/app_body.dart';
import 'package:thepcosprotocol_app/screens/authenticate.dart';
import 'package:thepcosprotocol_app/screens/register.dart';
import 'package:thepcosprotocol_app/screens/pin_set.dart';
import 'package:thepcosprotocol_app/screens/pin_unlock.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/widgets/other/app_loading.dart';
import 'package:thepcosprotocol_app/widgets/other/unsupported_version.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class PCOSProtocolApp extends StatefulWidget {
  //final ValueNotifier refreshMessages;

  //PCOSProtocolApp({@required this.refreshMessages});

  @override
  _PCOSProtocolAppState createState() => _PCOSProtocolAppState();
}

class _PCOSProtocolAppState extends State<PCOSProtocolApp>
    with WidgetsBindingObserver {
  AppState appState = AppState.LOADING;
  AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appOpeningCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //backgrounded - app was active (resumed) and is now inactive
    if (_appLifecycleState == AppLifecycleState.resumed &&
        state == AppLifecycleState.inactive) {
      if (appState == AppState.APP || appState == AppState.PIN_SET) {
        AuthenticationController()
            .saveBackgroundedTimestamp(DateTime.now().millisecondsSinceEpoch);
      }
    }

    //foregrounded - app was inactive and is now active (resumed)
    if ((_appLifecycleState == AppLifecycleState.inactive ||
            _appLifecycleState == AppLifecycleState.paused) &&
        state == AppLifecycleState.resumed) {
      appForegroundingCheck();
    }

    setState(() {
      _appLifecycleState = state;
    });
  }

  void appOpeningCheck() async {
    if (!await isVersionSupported()) {
      updateAppState(AppState.NOT_SUPPORTED);
    } else {
      final bool isUserLoggedIn =
          await AuthenticationController().isUserLoggedIn();

      if (isUserLoggedIn) {
        final bool isUserPinSet =
            await AuthenticationController().isUserPinSet();
        if (isUserPinSet) {
          updateAppState(AppState.LOCKED);
          return;
        }
      }
      updateAppState(AppState.SIGN_IN);
    }
  }

  // This function controls which screen the users sees when they foreground the app
  void appForegroundingCheck() async {
    if (!await isVersionSupported()) {
      updateAppState(AppState.NOT_SUPPORTED);
    } else if (appState != AppState.LOCKED) {
      final bool isUserLoggedIn =
          await AuthenticationController().isUserLoggedIn();

      if (isUserLoggedIn) {
        final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        final int backgroundedTimestamp =
            await AuthenticationController().getBackgroundedTimestamp();

        //need to check whether authenticated and has pin set?
        //check if app was backgrounded over five minutes (300,000 milliseconds) ago, and display lock screen if necessary

        final bool isUserPinSet =
            await AuthenticationController().isUserPinSet();
        if (isUserPinSet) {
          if (backgroundedTimestamp != null &&
              currentTimestamp - backgroundedTimestamp > 300000) {
            updateAppState(AppState.LOCKED);
          } else {
            updateAppState(AppState.APP);
          }
        } else {
          updateAppState(AppState.SIGN_IN);
        }
      } else if (appState != AppState.REGISTER) {
        updateAppState(AppState.SIGN_IN);
      }
    }
  }

  Future<bool> isVersionSupported() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String versionForChecker =
        version.substring(0, version.lastIndexOf("."));
    final String platformOS = Platform.isIOS ? "ios" : "android";
    return await WebServices().checkVersion(platformOS, versionForChecker);
  }

  void updateAppState(AppState newAppState) {
    setState(() {
      appState = newAppState;
    });
  }

  Widget getAuthenticationScreen(AppState appState) {
    switch (appState) {
      case AppState.PIN_SET:
        return PinSet(updateAppState: updateAppState);
      case AppState.REGISTER:
        return Register(updateAppState: updateAppState);
      case AppState.LOCKED:
        return PinUnlock(updateAppState: updateAppState);
      default:
        return Authenticate(updateAppState: updateAppState);
    }
  }

  @override
  Widget build(BuildContext context) {
    //this controls whether the not supported, signin, register or app are displayed using AppState
    switch (appState) {
      case AppState.LOADING:
        return AppLoading(
          backgroundColor: backgroundColor,
          valueColor: primaryColorDark,
        );
      case AppState.NOT_SUPPORTED:
        return UnsupportedVersion();
      case AppState.APP:
        return AppBody(
          updateAppState: updateAppState,
          //refreshMessages: widget.refreshMessages,
        );
      case AppState.SIGN_IN:
      case AppState.REGISTER:
      case AppState.PIN_SET:
      case AppState.LOCKED:
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          body: getAuthenticationScreen(appState),
        );
    }
    return Container();
  }
}
