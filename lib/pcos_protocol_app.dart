import 'package:flutter/material.dart';

import 'package:thepcosprotocol_app/widgets/app_body.dart';
import 'package:thepcosprotocol_app/screens/authenticate.dart';
import 'package:thepcosprotocol_app/screens/register.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';

class PCOSProtocolApp extends StatefulWidget {
  //NB: By setting this number high, will always show tabbed layout
  //    If we choose to have a different menu approach for iPads reduce
  //    number to say 600/700
  //Size screenSize = MediaQuery.of(context).size;
  //return screenSize.width < 10000 ? AppBody() : AppBodyLarge();
  @override
  _PCOSProtocolAppState createState() => _PCOSProtocolAppState();
}

class _PCOSProtocolAppState extends State<PCOSProtocolApp> {
  AppState appState = AppState.SIGNIN;

  void updateAppState(AppState newAppState) {
    debugPrint("appstate=$newAppState");
    setState(() {
      appState = newAppState;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("APPSTATE ON BUILD=$appState");
    //this controls whether the signin, register or app are displayed using AppState
    switch (appState) {
      case AppState.APP:
        debugPrint("APP");
        return AppBody();
      case AppState.SIGNIN:
        debugPrint("SIGNIN");
        return Authenticate(updateAppState: updateAppState);
      case AppState.REGISTER:
        debugPrint("REGISTER");
        return Register(updateAppState: updateAppState);
    }
  }
}
