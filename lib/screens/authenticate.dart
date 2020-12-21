import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/widgets/auth/sign_in.dart';
import 'package:thepcosprotocol_app/widgets/auth/goto_register.dart';
import 'package:thepcosprotocol_app/widgets/auth/authenticate_layout.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/controllers/authentication.dart';
import 'package:thepcosprotocol_app/utils/error_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class Authenticate extends StatefulWidget {
  final Function(AppState) updateAppState;

  Authenticate({this.updateAppState});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSigningIn = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void authenticateUser() async {
    setState(() {
      isSigningIn = true;
    });

    final String emailAddress = emailController.text.trim();
    final String password = passwordController.text.trim();
    // perform the authentication
    final bool signedIn = await Authentication().signIn(emailAddress, password);

    debugPrint("EMAIL=$emailAddress SIGNED IN=$signedIn");
    if (signedIn) {
      //success - this hides the login screen and shows the pin setup screen
      widget.updateAppState(AppState.PIN_SET);
    } else {
      setState(() {
        isSigningIn = false;
      });

      showFlushBar(context, S.of(context).signinErrorTitle,
          S.of(context).signinErrorText,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColorDark);
    }
  }

  void navigateToRegister() {
    widget.updateAppState(AppState.REGISTER);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: AuthenticateLayout(
        isHorizontal: DeviceUtils.isHorizontalWideScreen(
            screenSize.width, screenSize.height),
        screenSize: screenSize,
        signIn: SignIn(
          isSigningIn: isSigningIn,
          authenticateUser: authenticateUser,
          emailController: emailController,
          passwordController: passwordController,
        ),
        gotoRegister: GotoRegister(
            isSigningIn: isSigningIn, navigateToRegister: navigateToRegister),
      ),
    );
  }
}
