import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/authentication/forgot_password_success.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_generic.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  static const String id = "forgot_password_screen";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isSending = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void sendForgotPasswordRequest() async {
    bool showErrorDialog = false;
    String errorMessage = "";
    String errorTitle = "Request Failed";

    setState(() => isSending = true);

    final String email = emailController.text.trim();

    try {
      if (await WebServices().checkInternetConnectivity()) {
        final bool sendSuccessful =
            await AuthenticationController().forgotPassword(email: email);

        if (sendSuccessful) {
          Navigator.pushNamed(context, ForgotPasswordSuccess.id,
              arguments: email);
          return;
        } else {
          showErrorDialog = true;
          errorMessage = "An unknown error has occured";
        }
      } else {
        //not connected to internet, inform user
        showErrorDialog = true;
        errorTitle = S.current.internetConnectionTitle;
        errorMessage = S.current.internetConnectionText;
      }
    } catch (ex) {
      showErrorDialog = true;
      errorMessage = "Invalid user name, please try again";
    }
    if (showErrorDialog) {
      setState(() => isSending = false);

      showAlertDialog(
        context,
        errorTitle,
        errorMessage,
        "",
        "Okay",
        null,
        null,
      );
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: primaryColor,
            body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Header(closeItem: () => Navigator.pop(context)),
                      SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Expanded(
                          child: Container(
                            width: double.maxFinite,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Forgot password?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.copyWith(color: backgroundColor),
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    "Please enter you email address. You will receive a link to create a neww password via email.",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: textColor.withOpacity(0.8),
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  TextFormField(
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
                                  SizedBox(height: 40),
                                  FilledButton(
                                    margin: EdgeInsets.zero,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        sendForgotPasswordRequest();
                                      }
                                    },
                                    text: S.current.signInTitle,
                                    foregroundColor: Colors.white,
                                    backgroundColor: backgroundColor,
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (isSending) GenericLoaderOverlay()
              ],
            ),
          ),
        ),
      );
}
