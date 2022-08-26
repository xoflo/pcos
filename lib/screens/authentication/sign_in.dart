import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/widget_keys.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/screens/authentication/forgot_password.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_set.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
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
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay.dart';

class SignIn extends StatefulWidget {
  static const String id = "sign_in_screen";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isSigningIn = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

    setState(() => isSigningIn = true);

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

      showFlushBar(
        context,
        errorTitle,
        errorMessage,
        backgroundColor: Colors.white,
        borderColor: backgroundColor,
        primaryColor: backgroundColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    HeaderImage(
                      screenSize: screenSize,
                      isOrange: true,
                      verticalTopPadding: 80,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 60,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              child: TextFormField(
                                key: Key(WidgetKeys.SignInUsernameEmail),
                                controller: emailController,
                                cursorColor: backgroundColor,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: backgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: backgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: unselectedIndicatorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: unselectedIndicatorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: S.current.emailLabel,
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return S.current.validateEmailMessage;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                cursorColor: backgroundColor,
                                obscuringCharacter: "*",
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: backgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: backgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: unselectedIndicatorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: unselectedIndicatorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: S.current.passwordLabel,
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return S.current.validatePasswordMessage;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 15,
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, ForgotPassword.id),
                                child: Text(
                                  S.current.passwordForgottenTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: backgroundColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            FilledButton(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState?.validate() == true) {
                                  authenticateUser();
                                }
                              },
                              text: S.current.signInTitle,
                              foregroundColor: Colors.white,
                              backgroundColor: backgroundColor,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSigningIn) LoaderOverlay()
          ],
        ),
      ),
    );
  }
}
