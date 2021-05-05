import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_set.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/sign_in_layout.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/register_layout.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/member.dart';

class SignIn extends StatefulWidget {
  static const String id = "sign_in_screen";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isSigningIn = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void authenticateUser() async {
    bool showErrorDialog = false;
    String errorMessage = "";
    String errorTitle = S.of(context).signinErrorTitle;

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
              memberDetails.dateNextLessonAvailableLocal.toIso8601String());
          return;
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
          primaryColor: primaryColor);
    }
  }

  void navigateToRegister() async {
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
            S.of(context).questionnaireWebsiteErrorTitle,
            S
                .of(context)
                .questionnaireWebsiteErrorText
                .replaceAll("[url]", urlQuestionnaireWebsite),
            backgroundColor: Colors.white,
            borderColor: primaryColorLight,
            primaryColor: primaryColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double boxWidth = screenSize.width * 0.4;
    final bool isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: isHorizontal
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
                          navigateToRegister: navigateToRegister,
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
                      height: 170.0,
                      child: RegisterLayout(
                        navigateToRegister: navigateToRegister,
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
