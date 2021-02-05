import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';

class SignIn extends StatelessWidget {
  final bool isSigningIn;
  final Function() authenticateUser;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final _formKey = GlobalKey<FormState>();

  SignIn({
    this.isSigningIn,
    this.authenticateUser,
    this.emailController,
    this.passwordController,
  });

  void attemptSignIn() async {
    if (_formKey.currentState.validate()) {
      authenticateUser();
    }
  }

  void forgottenPassword(BuildContext context) {
    if (emailController.text.length == 0) {
      showAlertDialog(
          context,
          S.of(context).passwordForgottenTitle,
          S.of(context).passwordForgottenEmailMessage,
          S.of(context).okayText,
          "",
          () {});
    } else {
      showAlertDialog(
          context,
          S.of(context).passwordForgottenTitle,
          S
              .of(context)
              .passwordForgottenMessage
              .replaceAll("[emailAddress]", emailController.text),
          S.of(context).passwordForgottenCancel,
          S.of(context).passwordForgottenContinue,
          continueForgottenPassword);
    }
  }

  void continueForgottenPassword(BuildContext context) async {
    Navigator.of(context).pop();
    //send email to user
    try {
      final bool sendEmail =
          await WebServices().forgotPassword(emailController.text.trim());

      sendEmail
          ? S.of(context).passwordForgottenCompleteMessage
          : S.of(context).passwordForgottenFailedMessage;
      if (sendEmail) {
        showFlushBar(
          context,
          S.of(context).passwordForgottenTitle,
          S.of(context).passwordForgottenCompleteMessage,
          icon: Icons.info_rounded,
          backgroundColor: Colors.white,
          borderColor: secondaryColor,
          primaryColor: secondaryColor,
        );
      } else {
        showFlushBar(
          context,
          S.of(context).passwordForgottenTitle,
          S.of(context).passwordForgottenFailedMessage,
        );
      }
    } catch (ex) {
      showFlushBar(
        context,
        S.of(context).passwordForgottenTitle,
        S.of(context).passwordForgottenFailedMessage,
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
                  S.of(context).signInTitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.of(context).emailLabel,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).validateEmailMessage;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.of(context).passwordLabel,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).validatePasswordMessage;
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
                    isUpdating: isSigningIn,
                    label: S.of(context).signInTitle,
                    onTap: attemptSignIn,
                    width: 56,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      forgottenPassword(context);
                    },
                    child: Text(
                      S.of(context).passwordForgottenTitle,
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
