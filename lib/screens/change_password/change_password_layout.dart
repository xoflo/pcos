import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/widgets/shared/custom_text_field.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_generic.dart';

class ChangePasswordLayout extends StatefulWidget {
  @override
  _ChangePasswordLayoutState createState() => _ChangePasswordLayoutState();
}

class _ChangePasswordLayoutState extends State<ChangePasswordLayout> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isUpdating = false;

  void _savePassword(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
        parameters: {
          Analytics.ANALYTICS_PARAMETER_BUTTON:
              Analytics.ANALYTICS_BUTTON_CHANGE_PASSWORD
        },
      );

      String oldPassword = oldPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();
      String email = "";

      if (oldPassword != newPassword) {
        _displayMessage(S.current.changePasswordFailedTitle,
            "Your new password does not match, please try again");
        setState(() => isUpdating = false);
        return;
      }

      //check old password is correct, this is like logging in, so will return a new token that replaces the old one
      try {
        email = await AuthenticationController().getEmail() ?? "";
        await AuthenticationController().signIn(email, oldPassword);
      } catch (ex) {
        if (ex == SIGN_IN_CREDENTIALS) {
          //password must have been wrong
          _displayMessage(S.current.changePasswordOldPasswordWrongTitle,
              S.current.changePasswordOldPasswordWrongMessage);
        } else {
          //something else went wrong checking password
          _displayMessage(S.current.changePasswordFailedTitle,
              S.current.changePasswordFailedMessage);
        }
        setState(() => isUpdating = false);
        return;
      }

      //current password was correct so continue to update the new password
      try {
        final bool resetPassword =
            await WebServices().resetPassword(email, newPassword);
        if (resetPassword) {
          _cancel();
        }
      } catch (ex) {
        //something unexpected went wrong
        _displayMessage(S.current.changePasswordFailedTitle,
            S.current.changePasswordFailedMessage);
      }
    }
    setState(() => isUpdating = false);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _displayMessage(final String title, final String message) {
    showAlertDialog(
      context,
      title,
      message,
      "",
      "Okay",
      null,
      null,
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 12.0),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Header(
                      title: S.current.changePasswordTitle,
                      closeItem: _cancel,
                      showDivider: true,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              CustomTextField(
                                controller: oldPasswordController,
                                title: S.current.changePasswordOldLabel,
                                blankMessageError:
                                    S.current.changePasswordOldMessage,
                                isObscure: true,
                              ),
                              SizedBox(height: 15),
                              CustomTextField(
                                controller: newPasswordController,
                                title: S.current.changePasswordNewLabel,
                                blankMessageError:
                                    S.current.changePasswordNewMessage,
                                isObscure: true,
                              ),
                              SizedBox(height: 15),
                              CustomTextField(
                                controller: confirmPasswordController,
                                title: S.current.changePasswordConfirmLabel,
                                blankMessageError:
                                    S.current.changePasswordConfirmMessage,
                                isObscure: true,
                              ),
                              FilledButton(
                                text: "SAVE CHANGES",
                                margin: EdgeInsets.only(top: 25),
                                foregroundColor: Colors.white,
                                backgroundColor: backgroundColor,
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() => isUpdating = true);
                                  _savePassword(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUpdating) GenericLoaderOverlay()
        ],
      );
}
