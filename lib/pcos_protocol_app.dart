import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:thepcosprotocol_app/widgets/app_body.dart';
import 'package:thepcosprotocol_app/screens/authenticate.dart';
import 'package:thepcosprotocol_app/screens/register.dart';
import 'package:thepcosprotocol_app/screens/pin_set.dart';
import 'package:thepcosprotocol_app/screens/pin_unlock.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/controllers/authentication.dart';
import 'package:thepcosprotocol_app/widgets/other/app_loading.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class PCOSProtocolApp extends StatefulWidget {
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
        Authentication()
            .saveBackgroundedTimestamp(DateTime.now().millisecondsSinceEpoch);
      }
    }

    //foregrounded - app was inactive and is now active (resumed)
    if ((_appLifecycleState == AppLifecycleState.inactive ||
            _appLifecycleState == AppLifecycleState.paused) &&
        state == AppLifecycleState.resumed) {
      if (appState != AppState.LOCKED) {
        appForegroundingCheck();
      }
    }

    setState(() {
      _appLifecycleState = state;
    });
  }

  void appOpeningCheck() async {
    final bool isUserLoggedIn = await Authentication().isUserLoggedIn();

    if (isUserLoggedIn) {
      final bool isUserPinSet = await Authentication().isUserPinSet();
      if (isUserPinSet) {
        updateAppState(AppState.LOCKED);
        return;
      }
    }
    updateAppState(AppState.SIGN_IN);
  }

  // This function controls which screen the users sees when they foreground the app
  void appForegroundingCheck() async {
    final bool isUserLoggedIn = await Authentication().isUserLoggedIn();

    if (isUserLoggedIn) {
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final int backgroundedTimestamp =
          await Authentication().getBackgroundedTimestamp();

      //need to check whether authenticated and has pin set?
      //check if app was backgrounded over five minutes (300,000 milliseconds) ago, and display lock screen if necessary

      final bool isUserPinSet = await Authentication().isUserPinSet();
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
    //this controls whether the signin, register or app are displayed using AppState
    if (appState == AppState.LOADING) {
      return AppLoading(
        backgroundColor: backgroundColor,
        valueColor: primaryColorDark,
      );
    } else if (appState == AppState.APP) {
      return AppBody(updateAppState: updateAppState);
      //NB: By setting this number high, will always show tabbed layout
      //    If we choose to have a different menu approach for iPads reduce
      //    number to say 600/700
      //Size screenSize = MediaQuery.of(context).size;
      //return screenSize.width < 10000 ? AppBody() : AppBodyLarge();
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: getAuthenticationScreen(appState),
      );
    }
  }
}
