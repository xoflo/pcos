import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/widget_keys.dart';

class SignInLayout extends StatefulWidget {
  final bool isSigningIn;
  final Function() authenticateUser;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignInLayout({
    this.isSigningIn,
    this.authenticateUser,
    this.emailController,
    this.passwordController,
  });

  @override
  _SignInLayoutState createState() => _SignInLayoutState();
}

class _SignInLayoutState extends State<SignInLayout> {
  final _formKey = GlobalKey<FormState>();

  void attemptSignIn() async {
    if (_formKey.currentState.validate()) {
      widget.authenticateUser();
    }
  }

  void forgottenPassword(BuildContext context) {
    if (widget.emailController.text.length == 0) {
      showAlertDialog(
        context,
        S.current.passwordForgottenTitle,
        S.current.passwordForgottenEmailMessage,
        S.current.okayText,
        "",
        null,
        (BuildContext context) {
          Navigator.of(context).pop();
        },
      );
    } else {
      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
        parameters: {
          Analytics.ANALYTICS_PARAMETER_BUTTON:
              Analytics.ANALYTICS_BUTTON_FORGOTTEN_PWD
        },
      );
      showAlertDialog(
        context,
        S.current.passwordForgottenTitle,
        S
            .of(context)
            .passwordForgottenMessage
            .replaceAll("[emailAddress]", widget.emailController.text),
        S.current.passwordForgottenCancel,
        S.current.passwordForgottenContinue,
        continueForgottenPassword,
        (BuildContext context) {
          Navigator.of(context).pop();
        },
      );
    }
  }

  void continueForgottenPassword(BuildContext context) async {
    Navigator.of(context).pop();
    //send email to user
    try {
      final bool sendEmail = await WebServices()
          .forgotPassword(widget.emailController.text.trim());

      sendEmail
          ? S.current.passwordForgottenCompleteMessage
          : S.current.passwordForgottenFailedMessage;
      if (sendEmail) {
        showFlushBar(
          context,
          S.current.passwordForgottenTitle,
          S.current.passwordForgottenCompleteMessage,
          icon: Icons.info_rounded,
          backgroundColor: Colors.white,
          borderColor: secondaryColor,
          primaryColor: secondaryColor,
        );
      } else {
        showFlushBar(
          context,
          S.current.passwordForgottenTitle,
          S.current.passwordForgottenFailedMessage,
        );
      }
    } catch (ex) {
      showFlushBar(
        context,
        S.current.passwordForgottenTitle,
        S.current.passwordForgottenFailedMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: 30.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.signInTitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    key: Key(WidgetKeys.SignInUsernameEmail),
                    controller: widget.emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.current.emailLabel,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.validateEmailMessage;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: widget.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.current.passwordLabel,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.validatePasswordMessage;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: ColorButton(
                    isUpdating: widget.isSigningIn,
                    label: S.current.signInTitle,
                    onTap: attemptSignIn,
                    width: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      forgottenPassword(context);
                    },
                    child: Text(
                      S.current.passwordForgottenTitle,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
