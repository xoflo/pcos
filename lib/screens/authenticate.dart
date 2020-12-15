import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/widgets/auth/signin.dart';
import 'package:thepcosprotocol_app/widgets/auth/goto_register.dart';
import 'package:thepcosprotocol_app/widgets/auth/authenticate_layout.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/controllers/authentication.dart';

class Authenticate extends StatefulWidget {
  final Function(AppState) updateAppState;

  Authenticate({this.updateAppState});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSigningIn = false;

  void authenticateUser(
    final String emailAddress,
    final String password,
  ) async {
    setState(() {
      isSigningIn = true;
    });

    final bool signedIn = await Authentication().signIn(emailAddress, password);

    debugPrint("SIGNED IN=$signedIn");
    if (signedIn) {
      //this hides the login screen and shows the app
      widget.updateAppState(AppState.APP);
    } else {
      setState(() {
        isSigningIn = false;
      });
    }
  }

  void navigateToRegister() {
    debugPrint("register");
    widget.updateAppState(AppState.REGISTER);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SafeArea(
          child: AuthenticateLayout(
        isHorizontal: DeviceUtils.isHorizontalWideScreen(
            screenSize.width, screenSize.height),
        screenSize: screenSize,
        signIn: SignIn(
            isSigningIn: isSigningIn, authenticateUser: authenticateUser),
        gotoRegister: GotoRegister(
            isSigningIn: isSigningIn, navigateToRegister: navigateToRegister),
      )),
    );
  }
}
