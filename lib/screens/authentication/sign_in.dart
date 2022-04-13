import 'package:flutter/material.dart';
import 'dart:io';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_set.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/sign_in_layout.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/register_layout.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/register_web_view.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class SignIn extends StatefulWidget {
  static const String id = "sign_in_screen";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isSigningIn = false;
  bool showSignUp = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void authenticateUser() async {
    bool showErrorDialog = false;
    String errorMessage = "";
    String errorTitle = S.current.signinErrorTitle;

    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_BUTTON: Analytics.ANALYTICS_BUTTON_SIGN_IN
      },
    );

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
          analytics.logEvent(name: Analytics.ANALYTICS_EVENT_LOGIN);
          //if the first use timestamp hasn't been saved, save it now
          final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
          PreferencesController().saveInt(
              SharedPreferencesKeys.APP_FIRST_USE_TIMESTAMP, currentTimestamp);
          //success - this hides the login screen and shows the pin setup screen
          Navigator.pushReplacementNamed(context, PinSet.id);
          //get the dateNextLessonAvailable and update in shared prefs
          final Member memberDetails = await WebServices().getMemberDetails();
          await PreferencesController().saveString(
              SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE,
              memberDetails.dateNextLessonAvailableLocal?.toIso8601String() ??
                  "");
          return;
        } else {
          showErrorDialog = true;
          errorMessage = S.current.signinUnknownErrorText;
        }
      } else {
        //not connected to internet, inform user
        showErrorDialog = true;
        errorTitle = S.current.internetConnectionTitle;
        errorMessage = S.current.internetConnectionText;
      }
    } catch (ex) {
      showErrorDialog = true;
      switch (ex) {
        case EMAIL_NOT_VERIFIED:
          errorMessage = S.current.signInEmailNotVerifiedErrorText;
          break;
        case SIGN_IN_CREDENTIALS:
          errorMessage = S.current.signinErrorText;
          break;
        default:
          errorMessage = S.current.signinUnknownErrorText;
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
          primaryColor: primaryColor);
    }
  }

  void displayRegistration() async {
    if (!isSigningIn) {
      analytics.logEvent(name: Analytics.ANALYTICS_EVENT_SIGN_UP);
      setState(() {
        showSignUp = true;
      });
    }
  }

  void hideRegistration() async {
    setState(() {
      showSignUp = false;
    });
  }

  /*void navigateToRegister() async {
    if (!isSigningIn) {
      final urlQuestionnaireWebsite =
          FlavorConfig.instance.values.questionnaireUrl;
      if (await canLaunch(urlQuestionnaireWebsite)) {
        analytics.logEvent(name: Analytics.ANALYTICS_EVENT_SIGN_UP);

        await launch(
          urlQuestionnaireWebsite,
          forceSafariVC: false,
          forceWebView: false,
        );
      } else {
        showFlushBar(
            context,
            S.current.questionnaireWebsiteErrorTitle,
            S
                .of(context)
                .questionnaireWebsiteErrorText
                .replaceAll("[url]", urlQuestionnaireWebsite),
            backgroundColor: Colors.white,
            borderColor: primaryColorLight,
            primaryColor: primaryColor);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double boxWidth = screenSize.width * 0.4;
    final bool isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    final double heightDeduction = Platform.isIOS ? 60 : 64;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: showSignUp
            ? Column(
                children: [
                  SizedBox(
                    width: screenSize.width,
                    height: 40,
                    child: ColorButton(
                      isUpdating: false,
                      label: S.current.returnToSignInTitle,
                      onTap: hideRegistration,
                      width: 250,
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width,
                    height: screenSize.height - heightDeduction,
                    child: RegisterWebView(),
                  ),
                ],
              )
            : isHorizontal
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeaderImage(
                        screenSize: screenSize,
                        isOrange: false,
                        verticalTopPadding: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 340.0,
                            width: boxWidth,
                            child: SignInLayout(
                              isSigningIn: isSigningIn,
                              authenticateUser: authenticateUser,
                              emailController: emailController,
                              passwordController: passwordController,
                            ),
                          ),
                          SizedBox(
                            height: 340.0,
                            width: boxWidth,
                            child: RegisterLayout(
                              navigateToRegister: displayRegistration,
                              isHorizontal: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      children: <Widget>[
                        HeaderImage(
                          screenSize: screenSize,
                          isOrange: false,
                          verticalTopPadding: 80,
                        ),
                        SizedBox(
                          height: 360.0,
                          child: SignInLayout(
                            isSigningIn: isSigningIn,
                            authenticateUser: authenticateUser,
                            emailController: emailController,
                            passwordController: passwordController,
                          ),
                        ),
                        SizedBox(
                          height: 190.0,
                          child: RegisterLayout(
                            navigateToRegister: displayRegistration,
                            isHorizontal: false,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
