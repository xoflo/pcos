import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/widgets/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/widgets/authentication/goto_register.dart';
import 'package:thepcosprotocol_app/widgets/authentication/authenticate_layout.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';

class Authenticate extends StatefulWidget {
  final Function(AppState) updateAppState;

  Authenticate({this.updateAppState});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSigningIn = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void authenticateUser() async {
    bool showErrorDialog = false;
    String errorMessage = "";
    String errorTitle = S.of(context).signinErrorTitle;

    setState(() {
      isSigningIn = true;
    });

    final String emailOrUsername = emailController.text.trim();
    final String password = passwordController.text.trim();
    // perform the authentication
    try {
      if (await WebServices().checkInternetConnectivity()) {
        final bool signedIn =
            await AuthenticationController().signIn(emailOrUsername, password);

        if (signedIn) {
          //success - this hides the login screen and shows the pin setup screen
          widget.updateAppState(AppState.PIN_SET);
        } else {
          showErrorDialog = true;
          errorMessage = S.of(context).signinUnknownErrorText;
        }
      } else {
        //not connected to internet, inform user
        showErrorDialog = true;
        errorTitle = S.of(context).internetConnectionTitle;
        errorMessage = S.of(context).internetConnectionText;
      }
    } catch (ex) {
      showErrorDialog = true;
      debugPrint("ERROR=$ex");
      switch (ex) {
        case EMAIL_NOT_VERIFIED:
          errorMessage = S.of(context).signInEmailNotVerifiedErrorText;
          break;
        case SIGN_IN_CREDENTIALS:
          errorMessage = S.of(context).signinErrorText;
          break;
        default:
          errorMessage = S.of(context).signinUnknownErrorText;
          break;
      }
    }

    if (showErrorDialog) {
      setState(() {
        isSigningIn = false;
      });

      showFlushBar(context, errorTitle, errorMessage,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColorDark);
    }
  }

  void navigateToRegister() {
    if (!isSigningIn) {
      widget.updateAppState(AppState.REGISTER);
    }
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
        gotoRegister: GotoRegister(navigateToRegister: navigateToRegister),
      ),
    );
  }
}
